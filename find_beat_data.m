<div class="moz-text-flowed" style="font-family: -moz-fixed">function beat = find_beat_data(ecg, fs)

beat.check = 0; % reset check to incorrect beat detection, will be changed if a full beat data is found
beat.baseline = mean(ecg(1:fs/100)); % compute the baseline of heartbeat
                                  % depends on Stevan's begining of P and sampling freq.

ecg = ecg - beat.baseline; % adjust for non-zero baseline

beat.qrs.check = 0; % reset check to incorrect qrs, will be changed if a full qrs complex is found

beat.R = complex_part(ecg, 0, fs); % compute the R component of QRS

beat.Q = complex_part(-ecg(1:beat.R.left), 0, fs); % compute the Q component of QRS
                                                    % inverting the ECG data will help to reuse code
if (beat.Q.check)
    beat.Q.data = -beat.Q.data; % if Q was found, invert result to reconstruct origional data
end

beat.S = complex_part(-ecg(beat.R.right:end), beat.R.right-1, fs); % compute the S component of QRS
                                                                       % inverting the ECG data will help to reuse code
if (beat.S.check)
    beat.S.data = -beat.S.data; % if S was found, invert result to reconstruct origional data
end

if (beat.Q.check ~= 0) % compute the begining of QRS complex
    beat.qrs.left = beat.Q.left;
else
    beat.qrs.left = beat.R.left;
end

if (beat.S.check ~= 0) % compute the end of QRS complex
    beat.qrs.right = beat.S.right;
else
    beat.qrs.right = beat.R.right;
end

beat.qrs.duration = beat.qrs.right - beat.qrs.left + 1; % compute the duration of QRS complex

beat.qrs.check = beat.Q.check & beat.R.check & beat.S.check; % create global check for QRS: true if QRS was found

beat.P = complex_part(ecg(1:beat.qrs.left), 0, fs); % compute the P component of heartbeat
beat.T = complex_part(ecg(beat.qrs.right:end), beat.qrs.right-1, fs); % compute the T component of heartbeat

if (beat.T.check ~= 0) % if T was found, look for U
    beat.U = complex_part(ecg(beat.T.right:end), beat.T.right-1, fs); % compute the U component of heartbeat
else
    beat.U.check = 0;
end

beat.check = beat.qrs.check & beat.P.check & beat.T.check & beat.U.check;

end

function part = complex_part(ecg, offset, fs)

part.amplitude = max(ecg); % find the amplitude of component
part.indicator = find(part.amplitude == ecg); % find the index of peak

% find the zero crossings of component and use them as indicators of duration
part.left = find_zero_left(ecg, part.indicator, fs);
part.right = find_zero_right(ecg, part.indicator, fs);

if (part.left == -1 || part.right == -1) % check if component was dectected
    part.check = 0;
    return;
else
    part.check = 1;
    part.data = ecg(part.left:part.right);
end

% normalize the data to the origional data
part.indicator = part.indicator + offset;
part.left = part.left + offset;
part.right = part.right + offset;
part.duration = part.right - part.left + 1;

end

function index = find_zero_right(ecg, startIndex, fs)
index = find_zero(ecg, startIndex, 1, fs);
end

function index = find_zero_left(ecg, startIndex, fs)
index = find_zero(ecg, startIndex, -1, fs);
end

function index = find_zero(ecg, startIndex, direction, fs)

epsilon = max(abs(ecg))*10/fs; % range around zero which is tolerated as zero

if ((startIndex == 1) || (startIndex == length(ecg))) % check corners
    index = -1;
    return;
end

if (direction < 0) % determine ending index of searh 
    ending = 1;
else
    ending = length(ecg);
end

for n = startIndex : direction : ending % search ECG for first zero crossing
    if (abs(ecg(n)) <= epsilon)
        index = n;
        return;
    end
end

index = -1;

end</div>