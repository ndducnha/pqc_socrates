import traci
import random
import csv

def generate_vehicle_data(num_vehicles, num_samples):
    vehicle_data = []

    directions = {1: 'EB', 2: 'NB', 3: 'WB', 4: 'SB'}
    for vehicle_id in range(1, num_vehicles + 1):
        for sample in range(num_samples):
            local_x = random.uniform(0, 500)  # example range
            local_y = random.uniform(0, 500)  # example range
            v_vel = random.uniform(0, 100)  # example range
            direction = random.choice(list(directions.keys()))

            vehicle_data.append({
                'Vehicle_ID': vehicle_id,
                'Local_X': local_x,
                'Local_Y': local_y,
                'v_Vel': v_vel,
                'Direction': direction
            })
    
    return vehicle_data

def save_to_csv(vehicle_data, filename="vehicle_data.csv"):
    keys = vehicle_data[0].keys()
    with open(filename, 'w', newline='') as output_file:
        dict_writer = csv.DictWriter(output_file, fieldnames=keys)
        dict_writer.writeheader()
        dict_writer.writerows(vehicle_data)

# Start SUMO with TraCI
sumoBinary = "sumo-gui"  # or "sumo" for command line
sumoCmd = [sumoBinary, "-c", "/home/veins/src/veins/examples/veins/erlangen.sumo.cfg"]

traci.start(sumoCmd)

vehicle_data = generate_vehicle_data(100, 100)
save_to_csv(vehicle_data)

traci.close()
