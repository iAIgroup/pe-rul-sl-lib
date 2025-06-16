#!/usr/bin/env python3
"""
Battery Parameter Estimation and Optimization
==============================================

This script performs battery parameter estimation using retired battery data.
It processes discharge data, estimates battery parameters (qMax, Ro, wr) using
optimization algorithms, and saves simulation results.

Author: Battery Research Team
Date: 2025
"""

import numpy as np
import scipy.io
from progpy.loading import Piecewise
from progpy.models import BatteryElectroChem
from scipy.interpolate import interp1d

from batt_parameter_optimization_function import estimate_params, battery_working_condition_match

def load_battery_data(data_path):
    """
    Load retired battery data from .mat file

    Args:
        data_path (str): Path to the battery data file

    Returns:
        dict: Loaded battery data structure
    """
    try:
        return scipy.io.loadmat(data_path)['RetiredBatteryData_all'][0, 0]
    except FileNotFoundError:
        print(f"Error: Battery data file not found at {data_path}")
        raise
    except KeyError:
        print("Error: Expected data structure not found in .mat file")
        raise


def interpolate_discharge_data(time, voltage, temperature, interval=2):
    """
    Interpolate discharge data to regular time intervals

    Args:
        time (array): Original time data
        voltage (array): Original voltage data
        temperature (array): Original temperature data
        interval (int): Time interval for interpolation (seconds)

    Returns:
        tuple: Interpolated time, voltage, and temperature arrays
    """
    max_time = max(time)
    time_new = np.linspace(0, int(np.floor(max_time)),
                           int(np.floor(max_time / interval)) + 1)

    # Create interpolation functions
    voltage_interp = interp1d(time, voltage, kind='cubic')
    temperature_interp = interp1d(time, temperature, kind='cubic')

    # Interpolate data
    voltage_new = voltage_interp(time_new)
    temperature_new = temperature_interp(time_new)

    return time_new, voltage_new, temperature_new


def prepare_data_containers(time, current, voltage, temperature):
    """
    Prepare data containers for battery simulation

    Args:
        time (array): Time data
        current (array): Current data
        voltage (array): Voltage data
        temperature (array): Temperature data

    Returns:
        tuple: Dictionary containers for time, current, and voltage data
    """
    time_dict = [{'time': num} for num in time.tolist()]
    current_dict = [{'i': num} for num in current.tolist()]
    voltage_dict = [{'t': temp, 'v': volt} for temp, volt in
                    zip(temperature.tolist(), voltage.tolist())]

    return time_dict, current_dict, voltage_dict


def setup_battery_model(initial_temperature, interval):
    """
    Initialize and configure battery model

    Args:
        initial_temperature (float): Initial battery temperature in Celsius
        interval (int): Simulation time interval

    Returns:
        tuple: Configured battery model and initial state
    """
    # Initialize battery model
    battery = BatteryElectroChem()
    initial_state = battery.initialize()

    # Configure simulation options
    options = {'print': False, 'progress': False}
    options['dt'] = ('auto', interval)

    # Set up future loading profile (constant 5.2A discharge)
    future_loading = Piecewise(
        battery.InputContainer,
        [float('inf')],
        {'i': [5.2]}
    )

    # Disable noise for parameter estimation
    m_noise = battery.parameters['measurement_noise']
    battery.parameters['measurement_noise'] = 0
    p_noise = battery.parameters['process_noise']
    battery.parameters['process_noise'] = 0

    # Set battery parameters
    battery.parameters['VEOD'] = 2.75  # End of discharge voltage
    battery.parameters['x0']['tb'] = initial_temperature + 274.15  # Convert to Kelvin
    battery.parameters['tb'] = initial_temperature + 274.15
    battery.parameters['x0'] = initial_state

    return battery, initial_state


def process_battery_cycle(data_all, batch_name, battery_number, cycle_number,
                          mid_soc, dod, data_path, save_path, optimization_iter):
    """
    Process a single battery discharge cycle and estimate parameters

    Args:
        data_all (dict): All battery data
        batch_name (str): Batch identifier
        battery_number (int): Battery number in batch
        cycle_number (int): Cycle number to process
        mid_soc (float): Mid-point state of charge
        dod (float): Depth of discharge
        data_path (str): Path to battery data file
        save_path (str): Path to save simulation results
        optimization_iter (int): Number of optimization iterations

    Returns:
        tuple: Estimated parameters (qMax, Ro, wr)
    """
    print(f"Processing {batch_name}, Battery {battery_number}, Cycle {cycle_number}")

    # Extract discharge data for the specific cycle
    discharge_time = data_all[batch_name][0, battery_number][0][0][0][14 - 1][cycle_number - 1, :]
    discharge_voltage = data_all[batch_name][0, battery_number][0][0][0][8 - 1][cycle_number - 1, :]
    discharge_temperature = data_all[batch_name][0, battery_number][0][0][0][11 - 1][cycle_number - 1, :]

    # Create constant current array (5.2A discharge)
    discharge_current = 5.2 * np.ones_like(discharge_voltage)

    # Interpolate data to regular intervals
    interval = 2  # seconds
    time_interp, voltage_interp, temp_interp = interpolate_discharge_data(
        discharge_time, discharge_voltage, discharge_temperature, interval
    )

    # Update current array for interpolated data
    current_interp = 5.2 * np.ones_like(time_interp)

    # Prepare data containers for simulation
    time_dict, current_dict, voltage_dict = prepare_data_containers(
        time_interp, current_interp, voltage_interp, temp_interp
    )

    # Setup battery model
    battery, initial_state = setup_battery_model(temp_interp[0], interval)

    # Define parameters to estimate and their bounds
    parameter_keys = ['qMax', 'Ro', 'wr']
    parameter_bounds = {
        'qMax': (5500, 15000),  # Maximum capacity (mAh)
        'Ro': (0.04, 0.2),  # Internal resistance (Ohm)
        'wr': (4e-6, 12e-6)  # Warburg resistance parameter
    }

    # Estimate battery parameters using optimization
    qmax_est, ro_est, wr_est = estimate_params(
        battery, initial_state, mid_soc, dod,
        batch_name, battery_number, cycle_number,
        data_path, save_path, optimization_iter,
        times=time_interp.tolist(),
        inputs=current_dict,
        outputs=voltage_dict,
        keys=parameter_keys,
        bounds=parameter_bounds,
        method='L-BFGS-B',
        dt=interval,
        error_method='MAX_E'
    )

    return qmax_est, ro_est, wr_est


def main():
    """
    Main execution function for battery parameter estimation
    """
    # Configuration parameters
    BATTERY_DATA_PATH = r'RetiredBatteryData_all.mat'
    SAVING_FILE_PATH = r'Simulation_data_NASA'
    OPTIMIZATION_ITERATIONS = 80

    print("Loading battery data...")
    data_all = load_battery_data(BATTERY_DATA_PATH)

    # Define all available batches
    all_batches = [f'batch{i:02d}' for i in range(1, 22)]  # batch01 to batch21


    # Currently processing only batch01 (modify as needed)
    batches_to_process = ['batch01']

    # Process each batch
    for batch_name in batches_to_process:
        print(f"\nProcessing batch: {batch_name}")

        # Get battery working conditions for this batch
        mid_soc, dod = battery_working_condition_match(batch_name)
        print(f"Working conditions - Mid SOC: {mid_soc}, DOD: {dod}")

        # Define batteries to process (currently only battery #2)
        batteries_to_process = [2]

        for battery_number in batteries_to_process:
            print(f"\nProcessing battery number: {battery_number}")

            # Get number of cycles for this battery
            num_cycles = len(data_all[batch_name][0, battery_number][0][0][0][14 - 1])
            print(f"Total cycles available: {num_cycles}")

            # Process each cycle
            for cycle_idx in range(num_cycles):
                cycle_number = cycle_idx + 1

                try:
                    # Process the cycle and estimate parameters
                    qmax_est, ro_est, wr_est = process_battery_cycle(
                        data_all, batch_name, battery_number, cycle_number,
                        mid_soc, dod, BATTERY_DATA_PATH, SAVING_FILE_PATH,
                        OPTIMIZATION_ITERATIONS
                    )

                    print(f"Cycle {cycle_number} completed successfully")
                    print(f"  Estimated qMax: {qmax_est:.2f}")
                    print(f"  Estimated Ro: {ro_est:.6f}")
                    print(f"  Estimated wr: {wr_est:.2e}")

                except Exception as e:
                    print(f"Error processing cycle {cycle_number}: {str(e)}")
                    continue

    print("\nBattery parameter estimation completed!")


def rescale_array(arr, new_min=70, new_max=90):
    """
    Rescale array values to a new range (utility function - currently unused)

    Args:
        arr (array): Input array to rescale
        new_min (float): New minimum value
        new_max (float): New maximum value

    Returns:
        array: Rescaled array
    """
    arr_min, arr_max = arr.min(), arr.max()
    return ((arr - arr_min) / (arr_max - arr_min)) * (new_max - new_min) + new_min


if __name__ == "__main__":
    main()