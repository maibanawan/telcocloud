#!/usr/bin/env bash

cpu_util() {
    util=$(mpstat -P $1 | awk 'END{print $NF}')
    util=$(python -c "print 100.00 - ${util}")
}

compare() {
    first=$1
    second=$2
    op=$3

    python -c "print ${first} ${op} ${second}"
}

set_freq() {
    core=$1
    freq=$2
    sudo sh -c "echo -n "userspace" > /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_governor"
    sudo sh -c "echo -n ${freq} > /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_setspeed"
}

disable_core() {
    core=$1
    sudo sh -c "echo -n 0 > /sys/devices/system/cpu/cpu${core}/online"
}

enable_core() {
    cpus=12
    for ((core2=1;$core2 < ${cpus};core2++))
    do
        is_active2=$(cat /sys/devices/system/cpu/cpu${core2}/online)
        # Check if the CPU is not active
        if [ ${is_active2} -eq 0 ]
        then
            # The core is not active, activate this CPU core
            sudo sh -c "echo -n 1 > /sys/devices/system/cpu/cpu${core2}/online"
            break
        fi
    done
}

server_count() {
    # Finding the list of servers
    server_list=($(openstack server list | grep cirros | awk '{print $2}'))

    # The number of servers
    echo ${#server_list[@]}
}

increase_freq() {
    core=$1
    cur_freq=$(cpufreq-info -f -c ${core})

    available_freqs=($(cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_available_frequencies))
    for ((i=${#available_freqs[@] - 1}; i >= 0; i--))
    do
        freq=${available_freqs[i]}
        if [ ${freq} -gt ${cur_freq} ]
        then
            echo "AdaptE: Set CPU ${core} frequency to ${freq}"
            set_freq ${core} ${freq}
            break
        fi
    done
}

decrease_freq() {
    core=$1
    cur_freq=$(cpufreq-info -f -c ${core})

    available_freqs=($(cat /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_available_frequencies))
    for ((i=0; ${i} < ${#available_freqs[@]}; i++))
    do
        freq=${available_freqs[i]}
        if [ ${freq} -lt ${cur_freq} ]
        then
            echo "AdaptE: Set CPU ${core} frequency to ${freq}"
            set_freq ${core} ${freq}
            break
        fi
    done
}

adapt() {
    # Defining certain CPU core utilization thresholds
    # - Upper threshold for activating another CPU core
    active_thr_upper=95
    # - Lower threshold for deactivating a CPU core
    active_thr_lower=5
    # - Upper threshold to increase the frequency of a CPU core (if possible)
    freq_thr_upper=75
    # - Lower threshold to decrease the frequency of a CPU core (if possible)
    freq_thr_lower=25

    # CPU utilization and frequency, not touching CPU core 0
    cpus=12
    for ((core=1;$core < ${cpus};core++))
    do
        # Utilization and frequency
        cpu_util ${core}
        is_active=$(cat /sys/devices/system/cpu/cpu${core}/online)

        # Check if the CPU is not active
        if [ ${is_active} -eq 0 ]
        then
            # The CPU is not active, continue
            continue
        fi

        echo "Utilization of core ${core} is ${util}"

        comp=$(compare ${util} ${active_thr_upper} ">")
        if [ ${comp} = "True" ]
        then
            echo "AdaptE: Enable another CPU core, if available"
            enable_core
        fi

        comp=$(compare ${util} ${active_thr_lower} "<")
        if [ ${comp} = "True" ]
        then
            echo "AdaptE: Disable this CPU core"
            disable_core ${core}
        fi

        comp=$(compare ${util} ${freq_thr_upper} ">")
        if [ ${comp} = "True" ]
        then
            echo "AdaptE: Increase the frequency of ${core}, if possible"
            increase_freq ${core}
        fi

        comp=$(compare ${util} ${freq_thr_lower} "<")
        if [ ${comp} = "True" ]
        then
            echo "AdaptE: Decrease the frequency  of ${core}, if possible"
            decrease_freq ${core}
        fi
    done
}

run() {


    # Define a periodic value for the loop
    period=1

    # Adapt periodically
    count=$(server_count)

    while [ ${count} -gt 0 ]
    do
        adapt
        count=$(server_count)
        sleep ${period}
    done

    echo "AdaptE: AdaptE done!"
}

run

