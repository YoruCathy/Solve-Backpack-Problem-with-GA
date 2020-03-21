clear
population=10000;
%initialize a population with 'population' individuals

epoch=100;
%set the epoch numbers for the individuals to evolve

chrome=16;
%number of candidates to be put into the back pack

p_cross=0.9;
%probability of crossover
p_mutation=0.01;
%probability of mutation

%set properties of stuff and the backpack
global volumn;
volumn=[7 4 8 11 20 5 3 9 16 7 8 5 4 4 3 12]';
global weight;
weight=[11 7 9 6 7 8 5 6 18 2 3 6 2 9 5 4]';
global price;
price=[9 8 7 8 18 7 3 10 19 4 4 11 3 5 4 6]';
global max_volumn;
max_volumn=95;
global max_weight;
max_weight= 86;

%randomly initialize the first generation of population
ori_generation=init_pop(population,chrome);

y=zeros(epoch);
for i=1:epoch
    
    [fit_values,temp1]=fit_value(ori_generation);
    %calculate the fitting value and target function value
    
    [new_pop_after_select]=selection(temp1,fit_values);
    %select
    [new_pop_after_cross]=crossover(new_pop_after_select,p_cross);
    %cross over
    [new_pop_after_mutation]=mutation(new_pop_after_cross,p_mutation);
    %mutation
    
    [fit_values,temp2]=fit_value(new_pop_after_mutation);
    %calculate the fit value for every individual
    
    [best_individual,best_price]=best(temp2,fit_values);
    %get the best individual and its fitvalue, which is its packing scheme and its price
    y(i)=best_price;
    
    ori_generation=temp2;
    %update
end
x=(1:epoch);
plot(x,y,'b:');
legend('value');
hold on
xlabel('epoch');
ylabel('value');
[m,index]=max(fit_values);
best_price=m
best_scheme=best_individual
