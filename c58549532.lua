--パラメタルフォーズフュージョン
function c58549532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,58549532+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c58549532.target)
	e1:SetOperation(c58549532.activate)
	c:RegisterEffect(e1)
end
function c58549532.filter0(c,e)
	return c:IsCanBeFusionMaterial() and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsImmuneToEffect(e)
end
function c58549532.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c58549532.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xe1) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c58549532.fcheck(tp,sg,fc)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c58549532.gcheck(sg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c58549532.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		mg1:Merge(Duel.GetMatchingGroup(c58549532.filter0,tp,LOCATION_EXTRA,0,nil,e))
		aux.FCheckAdditional=c58549532.fcheck
		aux.GCheckAdditional=c58549532.gcheck
		local res=Duel.IsExistingMatchingCard(c58549532.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c58549532.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c58549532.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c58549532.filter1,nil,e)
	mg1:Merge(Duel.GetMatchingGroup(c58549532.filter0,tp,LOCATION_EXTRA,0,nil,e))
	aux.FCheckAdditional=c58549532.fcheck
	aux.GCheckAdditional=c58549532.gcheck
	local sg1=Duel.GetMatchingGroup(c58549532.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c58549532.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
end
