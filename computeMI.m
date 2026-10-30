function [I,M,SP] = computeMI(seq1,seq2,lag)
% function [I,M,SP] = computeMI(seq1,seq2,lag)
% Computes the mutual information (MI) between seq1 and seq2 at the
% given delay (lag) between the sequences.
%
%   Inputs:
%
%       seq1:   a discrete sequence of length N
%       seq2:   a discrete sequence of length N
%       lag:    the number of elements that seq1 is delayed with respect to
%               seq2 (a positive or negative integer). Default = 0;


if nargin <3
    lag = 0;
end

if(length(seq1) ~= length(seq2))
    error('Input sequences are of different length');
end


% Count the frequency and probability of each symbol in seq1
lambda1 = max(max(seq1));
symbol_count1 = zeros(lambda1,1);

for k = 1:lambda1
    symbol_count1(k) = (sum(seq1 == k));
end

symbol_prob1 = symbol_count1./sum(symbol_count1)+0.000001;


% Count the frequency and probability of each symbol in seq2
lambda2 = max(seq2);
symbol_count2 = zeros(lambda2,1);

for k = 1:lambda2
    symbol_count2(k) = sum(seq2 == k);
end

symbol_prob2 = symbol_count2./sum(symbol_count2)+0.000001;

% Compute the joint occurrence frequencies of symbol pairs at the given lag

M = zeros(lambda1,lambda2);
if(lag > 0)
    for k = 1:length(seq1)-lag
        loc1 = seq1(k);
        
        loc2 = seq2(k+lag);
        
        M(loc1,loc2) = M(loc1,loc2)+1;
    end
else
    for k = abs(lag)+1:length(seq1)
        loc1 = seq1(k);
        
        loc2 = 1;
        
        M(loc1,loc2) = M(loc1,loc2)+1;
    end
end

% Product of individual state probabilities as a matrix
SP = symbol_prob1*symbol_prob2';

% Pair joint probability
M = M./sum(M(:))+0.000001;

% Compute MI
I = sum(sum(M.*log2(M./SP)));
