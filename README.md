# README

This repository is still a WIP.

The repository contains the SuperCollider code for an interactive multichannel generative music installation.

## Samples

We are using these samples:

* cello samples by [Philarmonia Orchestra](http://www.philharmonia.co.uk/explore/sound_samples);
* piano samples by neatonk ( [MISStereoPiano pack](https://freesound.org/people/neatonk/packs/9133/) on freesound);

## Order of execution

### Calibration

First of all you must calibrate your audio setup: use files contained in _calibration_ folder. Simply load the _master_ patch and execute it. Then you can use functions contained inside the _test_area_ file.

White noise is going on all 8 speakers.
* You can turn on/off the audio.
* You can set volume for all speakers simultaneoulsy
* You can make EQ setting for alla speakers simultaneusly;

When the calibration is done you have got setting for the equalization:

#### mid eq 1
mid_freq1
mid_q1
mid_db1

#### mid eq 2
mid_freq2
mid_q2
mid_db2

#### mid eq 3
mid_freq3
mid_q3
mid_db3

#### filters
lpf_freq
hpf_freq

### Actual execution

Now that we have found all the equalization parameters, you can play the main patch.
Simply load the _master_ patch and execute it from the _sound_ root level.
Then you can use functions contained inside the _test_area_ file to test the audio.
