%Lab2
clear all
close all
clc

x = 0.1:1/22:1;
d = ((1 + 0.6*sin(2*pi*x/0.7) + 0.3*sin(2*pi*x))/2);
eta = 0.15;
n = 1;
plot(x,d,'r*');

w_11(n) = randn(1);
b_11(n) = randn(1);
w_12(n) = randn(1);
b_12(n) = randn(1);
w_13(n) = randn(1);
b_13(n) = randn(1);
w_14(n) = randn(1);
b_14(n) = randn(1);
w_15(n) = randn(1);
b_15(n) = randn(1);

w_21(n) = randn(1);
w_22(n) = randn(1);
w_23(n) = randn(1);
w_24(n) = randn(1);
w_25(n) = randn(1);
b_21(n) = randn(1);

e=randn(1);
y = zeros(1,20); % galutinis isejimas
e_total=ones(1,20);

while max(e_total) > 0.15
	for idx = 1:20
		v_11 = x(idx)*w_11(n)+b_11(n);
		v_12 = x(idx)*w_12(n)+b_12(n);
		v_13 = x(idx)*w_13(n)+b_13(n);
		v_14 = x(idx)*w_14(n)+b_14(n);
		v_15 = x(idx)*w_15(n)+b_15(n); 

		y_1 = 1/(1+exp(-v_11)); % pirmo sluoksnio isejimai
		y_2 = 1/(1+exp(-v_12));
		y_3 = 1/(1+exp(-v_13)); 
		y_4 = 1/(1+exp(-v_14)); 
		y_5 = 1/(1+exp(-v_15)); 

		v_21 = y_1*w_21(n) + y_2*w_22(n) + y_3*w_23(n) + y_4*w_24(n) + y_5*w_25(n) + b_21(n);
	
		%lokalus klaidos gradientas    
		delta1(n) = (1/(1+exp(-v_11))) * (1 - (1/(1+exp(-v_11))))*e*w_21(n);
		delta2(n) = (1/(1+exp(-v_12))) * (1 - (1/(1+exp(-v_12))))*e*w_22(n);
		delta3(n) = (1/(1+exp(-v_13))) * (1 - (1/(1+exp(-v_13))))*e*w_23(n);
		delta4(n) = (1/(1+exp(-v_14))) * (1 - (1/(1+exp(-v_14))))*e*w_24(n);
		delta5(n) = (1/(1+exp(-v_15))) * (1 - (1/(1+exp(-v_15))))*e*w_25(n);

		%pasleptojo sluoksnio svoriu atnaujinimas
		w_11(n+1) = w_11(n) + eta*delta1(n)*x(idx);
		w_12(n+1) = w_12(n) + eta*delta2(n)*x(idx);
		w_13(n+1) = w_13(n) + eta*delta3(n)*x(idx);
		w_14(n+1) = w_14(n) + eta*delta4(n)*x(idx);
		w_15(n+1) = w_15(n) + eta*delta5(n)*x(idx);
		b_11(n+1) = b_11(n) + eta*delta1(n);
		b_12(n+1) = b_12(n) + eta*delta2(n);
		b_13(n+1) = b_13(n) + eta*delta3(n);
		b_14(n+1) = b_14(n) + eta*delta4(n);
		b_15(n+1) = b_15(n) + eta*delta5(n);

		% isejimo sluoksnio svoriu atnaujinimas
		w_23(n+1) = w_23(n) + eta*e*(1/(1+exp(-x(idx)*w_13(n)-b_13(n))));
		w_24(n+1) = w_24(n) + eta*e*(1/(1+exp(-x(idx)*w_14(n)-b_14(n))));
		w_25(n+1) = w_25(n) + eta*e*(1/(1+exp(-x(idx)*w_15(n)-b_15(n))));
		w_22(n+1) = w_22(n) + eta*e*(1/(1+exp(-x(idx)*w_12(n)-b_12(n))));
		w_21(n+1) = w_21(n) + eta*e*(1/(1+exp(-x(idx)*w_11(n)-b_11(n))));
		b_21(n+1) = b_21(n) + eta*e*1;
	
		y(idx) = v_21;
		
		%calculate error
		e = d(idx) - y(idx);

		e_total(idx) = e; 
		n = n + 1;
	end %for
end %while

y_out = zeros(20,1);

for id = 1:20
	%Patikrinimas su atnaujintais koeficientais
	v_11 = x(id)*w_11(n)+b_11(n);
	v_12 = x(id)*w_12(n)+b_12(n);
	v_13 = x(id)*w_13(n)+b_13(n);
	v_14 = x(id)*w_14(n)+b_14(n);
	v_15 = x(id)*w_15(n)+b_15(n); 

	y_1 = 1/(1+exp(-v_11)); 
	y_2 = 1/(1+exp(-v_12));
	y_3 = 1/(1+exp(-v_13)); 
	y_4 = 1/(1+exp(-v_14)); 
	y_5 = 1/(1+exp(-v_15)); 

	v_21 = y_1*w_21(n) + y_2*w_22(n) + y_3*w_23(n) + y_4*w_24(n) + y_5*w_25(n) + b_21(n);
	
	%calculate error
	y_out(id) = v_21;
end %for
		
figure, plot(x, d, 'g*', x, y_out, 'r*');






