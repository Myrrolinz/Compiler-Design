#include "Function.h"
#include "Unit.h"
#include "Type.h"
#include "Ast.h"
#include <list>
#include <fstream>
#include <stack>
extern Ast ast;
extern FILE* yyout;

Function::Function(Unit *u, SymbolEntry *s)
{
    u->insertFunc(this);
    entry = new BasicBlock(this);
    sym_ptr = s;
    parent = u;
}

Function::Function(Unit *u, SymbolEntry *s,std::vector<Type*> params)
{
    u->insertFunc(this);
    entry = new BasicBlock(this);
    sym_ptr = s;
    parent = u;
    this->params=params;
    
}


Function::~Function()
{/*
    auto delete_list = block_list;
    for (auto &i : delete_list)
        delete i;
    parent->removeFunc(this);
*/
}

// remove the basicblock bb from its block_list.
void Function::remove(BasicBlock *bb)
{
    block_list.erase(std::find(block_list.begin(), block_list.end(), bb));
}

void Function::output() const
{
    FunctionType* funcType = dynamic_cast<FunctionType*>(sym_ptr->getType());
    Type *retType = funcType->getRetType();
    int para_num=funcType->getnum();
    std::vector<Type *> Params=funcType->get_vector_type();
   // fprintf(stderr, "断点1 \n");
    if(para_num==0)
    {
        //fprintf(stderr, "断点1 \n");
        //retType为类型变脸，其toStr()输出该Type类的size长度 32 or 1
        //sym_ptr为SymbolEntry类型，其toStr()输出该符号表项的类型
        //输出格式 define i32 int()
        fprintf(yyout, "define %s %s() {\n", retType->toStr().c_str(), sym_ptr->toStr().c_str());
    }
    //针对有参数情况 需要把参数也输出
    else{
        
        //fprintf(stderr, "断点2 \n");
        //输出格式 define i32 int(
        fprintf(yyout, "define %s %s(", retType->toStr().c_str(), sym_ptr->toStr().c_str());
        
        //std::vector<Type*>::const_iterator it;
        //it=getparam_begin();//获取参数向量的头部迭代器
         std::vector<Type *>::iterator it=Params.begin();//获得首部参数
        //按照参数格式输出
        //fprintf(stderr, "%d \n", int(Params.size()));
        //fprintf(stderr, "%s \n ", (*it)->toStr().c_str());
        //  fprintf(stderr, "函数断点3 \n");
        Type *temp=*it;
        //fprintf(stderr, "断点3 \n");
        int i=0;
        std::stack<int>tmp;
        //AllFuncParams：参数从右往左入栈，输出时要最先输出左部参数，因此采取栈结构，参数顺序调换后输出
        for(;i<para_num;i++){//复制一遍所有函数的参数列表
            tmp.push(ast.AllFuncParams.front());
            ast.AllFuncParams.pop_front();
            //fprintf(yyout, "%s \%t%d,", temp->toStr.c_str, )
        } 
        for(;tmp.size()>1;){
            fprintf(yyout, "%s %%t%d, ",temp->toStr().c_str(), tmp.top());
            tmp.pop();
        }
        fprintf(yyout, "%s %%t%d){", temp->toStr().c_str(), tmp.top());
        fprintf(yyout,"\n");
        /*
        for(;i<para_num-1;i++)
        {
            
            fprintf(yyout, "%s %%%d,", temp->toStr().c_str(),i);
            it++;
            temp=*it;
        }
       
        fprintf(yyout, "%s %%%d) {\n", temp->toStr().c_str(),i);
        */
    }
    // fprintf(stderr, "断点2 \n");
    //从entry当前函数的入口开始遍历输出指令内容
    std::set<BasicBlock *> v;
    std::list<BasicBlock *> q;
    q.push_back(entry);
    v.insert(entry);
    //fprintf(stderr, "断点3 \n");
    while (!q.empty())
    {
        auto bb = q.front();
        q.pop_front();
        bb->output();//输出每个块
        //fprintf(stderr, "断点1 \n");
        //每个块可能有多个后继块 所以都要遍历
        for (auto succ = bb->succ_begin(); succ != bb->succ_end(); succ++)
        {
            //fprintf(stderr, "断点2 \n");
            if (v.find(*succ) == v.end())
            {
                v.insert(*succ);
                q.push_back(*succ);
            }
        }
    }
    fprintf(yyout, "}\n");
    //fprintf(stderr, "断点4 \n");
}
