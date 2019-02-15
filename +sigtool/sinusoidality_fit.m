function [phase_of_peak, amplitude, y_offset, start_phase] = sinusoidality_fit(x, y)
% x should be in radians, i.e. pi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_foo         = @(x, off, amp, phase) off + (amp * sin(x + phase));
g               = fittype('y_offset + (amplitude * sin(x + start_phase))',...
                        'coefficients',{'y_offset','amplitude','start_phase'});
gopt            = fitoptions(g);

start_y_offset  = mean(y);
start_amplitude = range(y-mean(y))/2;
start_phase     = angle(hilbert(y));
start_phase     = start_phase(1);

gopt.StartPoint = [start_y_offset, start_amplitude, start_phase];
gopt.Lower      = [-Inf 0 -pi] ;
gopt.Upper      = [Inf Inf +pi];
gm              = fit(x, y, g, gopt);
%y_hat           = fit_foo(x, gm.y_offset, gm.amplitude, gm.start_phase);

tmp_x           = -pi:0.0001:pi;
tmp_y           = fit_foo(tmp_x, gm.y_offset, gm.amplitude, gm.start_phase);
[~, idx]        = sort(tmp_y, 'descend');

phase_of_peak   = tmp_x(idx(1));
amplitude       = gm.amplitude;
y_offset        = gm.y_offset;
start_phase     = gm.start_phase;

end