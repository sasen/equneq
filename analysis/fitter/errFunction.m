function err = errFunction(p,data)
% function err = errFunction(p,data)
% from jserences, attempted mashup by sasen for log-likelihood
% plotting disabled

%% error walls
if (p.g < 0) || (p.g > 1) || (p.l < 0) || (p.l > 1)
    err = 10000000;
    return;
end
%%
pred = model(p); %get a prediction of the data
err = sum((pred-data).^2); % then compute the SSE between pred and data
%err = sum(abs(pred-data));

%% LOGLIKE: weight 2afc choices by number of trials
% nLeft  = data.*p.n;
% nRight = (1-data).*p.n;
% logLike=sum(nLeft.*log(pred)) + sum(nRight.*log(1-pred));
% err = -logLike;

%% Plotting
% if p.plot==1
%     figure(1);
%     clf
%     plot(p.x, pred, 'b', 'LineWidth', 2), hold on
%     plot(p.x, data, 'k', 'LineWidth', 2)
%     drawnow
% end

