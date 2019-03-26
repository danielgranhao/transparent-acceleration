// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

scalar dummyScalar;
scalar fScalarIsForced=0;
scalar fScalarIsReleased=0;
scalar fScalarHasChanged=0;
scalar fForceFromNonRoot=0;
scalar fNettypeIsForced=0;
scalar fNettypeIsReleased=0;
void  hsG_0 (struct dummyq_struct * I1104, EBLK  * I1105, U  I654);
void  hsG_0 (struct dummyq_struct * I1104, EBLK  * I1105, U  I654)
{
    U  I1348;
    U  I1349;
    U  I1350;
    struct futq * I1351;
    I1348 = ((U )vcs_clocks) + I654;
    I1350 = I1348 & ((1 << fHashTableSize) - 1);
    I1105->I700 = (EBLK  *)(-1);
    I1105->I704 = I1348;
    if (I1348 < (U )vcs_clocks) {
        I1349 = ((U  *)&vcs_clocks)[1];
        sched_millenium(I1104, I1105, I1349 + 1, I1348);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I654 == 1)) {
        I1105->I705 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I700 = I1105;
        peblkFutQ1Tail = I1105;
    }
    else if ((I1351 = I1104->I1063[I1350].I717)) {
        I1105->I705 = (struct eblk *)I1351->I716;
        I1351->I716->I700 = (RP )I1105;
        I1351->I716 = (RmaEblk  *)I1105;
    }
    else {
        sched_hsopt(I1104, I1105, I1348);
    }
}
void  hsM_1_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    typedef
    UB
     * TermTypePtr;
    U  I1139;
    U  I955;
    TermTypePtr  I1152;
    scalar  * I853;
    I1152 = (TermTypePtr )pcode;
    I955 = *I1152;
    I1152 -= I955;
    I853 = (scalar  *)(I1152 + 2U);
    if (I853[I955] == val) {
        return  ;
    }
    I853[I955] = val;
    val = I853[0];
    val = Xunion[(val << 7) + I853[1U]];
    pcode = ((UB  *)I1152) + 4U;
    {
        U  I1169 = 0;
        pcode = (UB  *)((UB  *)(((RP )pcode + I1169 + 7) & ~7));
    }
    {
        struct dummyq_struct * I1104;
        EBLK  * I1105;
        I1104 = (struct dummyq_struct *)&vcs_clocks;
        if (*(scalar  *)((pcode + 0) + 24U) != val) {
            RmaEblk  * I1105 = (RmaEblk  *)(pcode + 0);
            *(scalar  *)((pcode + 0) + 24U) = val;
            if (!(I1105->I700)) {
                I1104->I1058->I700 = (EBLK  *)I1105;
                I1104->I1058 = (EBLK  *)I1105;
            }
        }
    }
}
void  hsM_1_5__ase_simv_daidir (UB  * pcode, UB  val)
{
    typedef
    UB
     * TermTypePtr;
    U  I1139;
    U  I955;
    TermTypePtr  I1152;
    scalar  * I853;
    I1152 = (TermTypePtr )pcode;
    I955 = *I1152;
    I1152 -= I955;
    I853 = (scalar  *)(I1152 + 2U);
    val = I853[I955];
    I853[I955] = 0xff;
    hsM_1_0__ase_simv_daidir(pcode, val);
}
void  hsM_1_9__ase_simv_daidir (UB  * pcode, scalar  val)
{
    val = *(scalar  *)((pcode + 0) + 24U);
    if (*(pcode + 40) == val) {
        return  ;
    }
    *(pcode + 40) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 48);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 56);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
}
void  hsM_7_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    typedef
    UB
     * TermTypePtr;
    U  I1139;
    U  I955;
    TermTypePtr  I1152;
    scalar  * I853;
    I1152 = (TermTypePtr )pcode;
    I955 = *I1152;
    I1152 -= I955;
    I853 = (scalar  *)(I1152 + 2U);
    if (I853[I955] == val) {
        return  ;
    }
    I853[I955] = val;
    val = I853[0];
    val = Xunion[(val << 7) + I853[1U]];
    pcode = ((UB  *)I1152) + 4U;
    {
        U  I1169 = 0;
        pcode = (UB  *)((UB  *)(((RP )pcode + I1169 + 7) & ~7));
    }
    {
        struct dummyq_struct * I1104;
        EBLK  * I1105;
        I1104 = (struct dummyq_struct *)&vcs_clocks;
        if (*(scalar  *)((pcode + 0) + 24U) != val) {
            RmaEblk  * I1105 = (RmaEblk  *)(pcode + 0);
            *(scalar  *)((pcode + 0) + 24U) = val;
            if (!(I1105->I700)) {
                I1104->I1058->I700 = (EBLK  *)I1105;
                I1104->I1058 = (EBLK  *)I1105;
            }
        }
    }
}
void  hsM_7_9__ase_simv_daidir (UB  * pcode, scalar  val)
{
    val = *(scalar  *)((pcode + 0) + 24U);
    if (*(pcode + 40) == val) {
        return  ;
    }
    *(pcode + 40) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 48);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 56);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
}
void  hsM_8_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    typedef
    UB
     * TermTypePtr;
    U  I1139;
    U  I955;
    TermTypePtr  I1152;
    scalar  * I853;
    I1152 = (TermTypePtr )pcode;
    I955 = *I1152;
    I1152 -= I955;
    I853 = (scalar  *)(I1152 + 2U);
    if (I853[I955] == val) {
        return  ;
    }
    I853[I955] = val;
    val = I853[0];
    val = Xunion[(val << 7) + I853[1U]];
    pcode = ((UB  *)I1152) + 4U;
    {
        U  I1169 = 0;
        pcode = (UB  *)((UB  *)(((RP )pcode + I1169 + 7) & ~7));
    }
    {
        struct dummyq_struct * I1104;
        EBLK  * I1105;
        I1104 = (struct dummyq_struct *)&vcs_clocks;
        if (*(scalar  *)((pcode + 0) + 24U) != val) {
            RmaEblk  * I1105 = (RmaEblk  *)(pcode + 0);
            *(scalar  *)((pcode + 0) + 24U) = val;
            if (!(I1105->I700)) {
                I1104->I1058->I700 = (EBLK  *)I1105;
                I1104->I1058 = (EBLK  *)I1105;
            }
        }
    }
}
void  hsM_8_5__ase_simv_daidir (UB  * pcode, UB  val)
{
    typedef
    UB
     * TermTypePtr;
    U  I1139;
    U  I955;
    TermTypePtr  I1152;
    scalar  * I853;
    I1152 = (TermTypePtr )pcode;
    I955 = *I1152;
    I1152 -= I955;
    I853 = (scalar  *)(I1152 + 2U);
    val = I853[I955];
    I853[I955] = 0xff;
    hsM_8_0__ase_simv_daidir(pcode, val);
}
void  hsM_8_9__ase_simv_daidir (UB  * pcode, scalar  val)
{
    val = *(scalar  *)((pcode + 0) + 24U);
    if (*(pcode + 40) == val) {
        return  ;
    }
    *(pcode + 40) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 48);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 56);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
}
void  hsM_9_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    *(pcode + 0) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 8);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 16);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
}
void  hsM_9_5__ase_simv_daidir (UB  * pcode, UB  val)
{
    val = *(pcode + 0);
    *(pcode + 0) = 0xff;
    hsM_9_0__ase_simv_daidir(pcode, val);
}
void  hsM_15_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    *(pcode + 0) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 8);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 16);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
}
void  hsM_15_5__ase_simv_daidir (UB  * pcode, UB  val)
{
    val = *(pcode + 0);
    *(pcode + 0) = 0xff;
    hsM_15_0__ase_simv_daidir(pcode, val);
}
void  hsM_16_0__ase_simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1408;
    *(pcode + 0) = val;
    {
        RP  I1285;
        RP  * I694 = (RP  *)(pcode + 8);
        {
            I1285 = *I694;
            if (I1285) {
                hsimDispatchCbkMemOptNoDynElabS(I694, val, 1U);
            }
        }
    }
    {
        RmaNbaGate1  * I1199 = (RmaNbaGate1  *)(pcode + 16);
        scalar  I949 = X4val[val];
        I1199->I956.I792.I768 = I949;
        NBA_Semiler(0, &I1199->I956);
    }
    {
        scalar  I1119;
        I1119 = val;
        (*(FP  *)(pcode + 96))(*(UB  **)(pcode + 104), I1119);
    }
}
void  hsM_16_5__ase_simv_daidir (UB  * pcode, UB  val)
{
    val = *(pcode + 0);
    *(pcode + 0) = 0xff;
    hsM_16_0__ase_simv_daidir(pcode, val);
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
