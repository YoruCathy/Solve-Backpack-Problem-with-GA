clear
population=10000;
epoch=100;
chrome=16;
p_cross=0.9;
p_mutation=0.01;

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

ori_generation=init_pop(population,chrome);

y=zeros(epoch);
for i=1:epoch
    
    [fit_values,temp1]=fit_value(ori_generation); %计算适应度
    
    [new_pop_after_select]=selection(temp1,fit_values); %选择
    [new_pop_after_cross]=crossover(new_pop_after_select,p_cross); %交叉
    [new_pop_after_mutation]=mutation(new_pop_after_cross,p_mutation); %变异
    
    [fit_values,temp2]=fit_value(new_pop_after_mutation); %计算适应度

    
    [best_individual,best_price]=find_best(temp2,fit_values);
    %获取最优个体
    y(i)=best_price;
    
    ori_generation=temp2;
    %更新
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

%计算适应度
function [fitvalue,poptemp]=fit_value(pop)
global price;
global weight;
global volumn;
global max_weight;
global max_volumn;
[px,~,~]=size(pop);
for i=1:px
    obj_value(i)=pop(i,:)*price;
    wei_value(i)=pop(i,:)*weight;
    vo_value(i)=pop(i,:)*volumn;
end

for i=1:px
    if wei_value(i)<=max_weight && vo_value(i)<=max_volumn
        temp=obj_value(i);
    else
        temp=0;
    end
    fitvalue(i)=temp;
end

[maxfit,mn]=max(fitvalue);
for i=1:px
    if wei_value(i)>86 || vo_value(i)>95
        poptemp(i,:)=pop(mn,:);
        fitvalue(i)=maxfit;
    else
        poptemp(i,:)=pop(i,:);
    end
end

fitvalue=fitvalue';
end

%交叉
function [newpop]=crossover(pop,pc)
[px,py]=size(pop);
newpop=ones(size(pop));
for i=1:2:px-1
    if(rand<pc)
        cpoint=round(rand*py);
        newpop(i,:)=[pop(i,1:cpoint),pop(i+1,cpoint+1:py)];
        newpop(i+1,:)=[pop(i+1,1:cpoint),pop(i,cpoint+1:py)];
    else
        newpop(i,:)=pop(i,:);
        newpop(i+1,:)=pop(i+1,:);
    end
end
end

%变异
function [new_pop]=mutation(pop,p_mut)
[px,py]=size(pop);
new_pop=ones(size(pop));
for i=1:px
    if(rand<p_mut)
        m_pos=round(rand*py);
        if m_pos<=0
            m_pos=1;
        end
        new_pop(i,:)=pop(i,:);
        if any(new_pop(i,m_pos))==0
            new_pop(i,m_pos)=1;
        else
            new_pop(i,m_pos)=0;
        end
    else
        new_pop(i,:)=pop(i,:);
    end
end
end

%选择
function [new_pop]=selection(pop,fit_value)
total_fit=sum(fit_value);
fit_value=fit_value/total_fit;
fit_value=cumsum(fit_value);
[px,~]=size(pop);
ms=sort(rand(px,1));
fit_in=1;
new_in=1;
while new_in<=px
    if(ms(new_in))<fit_value(fit_in)
        new_pop(new_in,:)=pop(fit_in,:);
        new_in=new_in+1;
    else
        fit_in=fit_in+1;
    end
end
end

%初始化种群
function pop=init_pop(population,chrome)
pop=round(rand(population,chrome));
end

%找最优个体
function [best_individual,best_fit]=find_best(population,fit_values)
[px,py]=size(population);
best_individual=population(1,:);
best_fit=fit_values(1);
for i=2:px
    if fit_values(i)>best_fit
        best_individual=population(i,:);
        best_fit=fit_values(i);
    end
end
end
