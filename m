Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681513126D0;
	Wed, 15 Apr 2026 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776221380; cv=none; b=Rh8up2qFaGQwYLgU+MM9nDiqIq0Noa5qVsZEq/OFEMTgIwHP+Pde9RRZzXitE6DxSAX7MYA2ja7vL5Qe+gyvETnliD3nmnSF/Lo8mn4WaS3qsrWVZQXdcHxT4lRfVDm33ILcyyt56FW+Obx0KIsmaLlwy0lPS5ll2a4jF4jJZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776221380; c=relaxed/simple;
	bh=0AuenaOfmDE99zOKcXCll7vxX25cPALTWSc7lA12r8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ne1agljSJhoO917YV2sURDHdA80yVEpBSe7AxA/FVh4R0roBIbGuqv7hiwmlxA3E6HWiqVsaY0hQf8gZNu1v88rBmYDPthKpHI+QTWM9pDWrJHV/ajxeirXWYoCwxJ5xveDEOkuoJCritEx3y94hF53bM55i+CbZReyzraKI3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NC5av1rK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC5av1rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D342C19425;
	Wed, 15 Apr 2026 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776221380;
	bh=0AuenaOfmDE99zOKcXCll7vxX25cPALTWSc7lA12r8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NC5av1rK5RQMpd3VkE01VXX28D1NScamat3D2yU/BLI8M1aEWTiYwpWiegGHcWJYL
	 5D7bg6J7MBdvO3JFbWT81/VtG6f4XuKg7OW8dvX8Saggo+z1MD4VfhrDpMj3si+Hx0
	 cGziEv8MqIqcr3UENYdXBhswntrvfMSlkmgw6vIpGzZB/tS7X2XJ5nGIptdpmgMEi3
	 MRATSuz3y+uSYhyvRJbPgaLQ0/Z3OeI3+b77lRiNP80EFPL3XLBdriGjt5du1mzSSm
	 Uf3wTYkuMu7h5Ze2RdLHRqSDbY5BFDLDnVpFXR9XPTY0Sz3th2WGiEkAwNyVT6j2tT
	 63CLqfkHl62lg==
Date: Wed, 15 Apr 2026 05:49:36 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>, Kai Huang <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSB4?= =?utf-8?Q?86=2Fsgx?=
 =?utf-8?Q?=3A?= Use list_for_each_entry_srcu() for mm_list traversal
Message-ID: <ad78wMV3Au2yN4ko@kernel.org>
References: <20260226014014.2541-1-lirongqing@baidu.com>
 <484ff5a62fee43618b30bbafb1ab3723@baidu.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484ff5a62fee43618b30bbafb1ab3723@baidu.com>

On Tue, Apr 14, 2026 at 07:47:54AM +0000, Li,Rongqing(ACG CCN) wrote:
> 
> 
> > From: Li RongQing <lirongqing@baidu.com>
> > 
> > In commit 1728ab54b4be ("x86/sgx: Add a page reclaimer") (v5.11),
> > list_for_each_entry_rcu() was used to traverse the enclave's mm_list.
> > However, this is incorrect because the list is protected by a Sleepable RCU (SRCU)
> > lock (encl->srcu).
> > 
> > Since commit 28875945ba98 ("rcu: Add support for consolidated-RCU reader
> > checking") (v5.4), RCU lockdep checking has become stricter. When
> > CONFIG_PROVE_RCU is enabled, using the standard list_for_each_entry_rcu()
> > while only holding an SRCU lock triggers "suspicious RCU usage" false positive
> > warnings, as it does not recognize SRCU read-side critical sections.
> > 
> > Fix this by switching to list_for_each_entry_srcu(), which was introduced
> > specifically for this purpose in commit ae2212a7216b
> > ("rculist: Introduce list/hlist_for_each_entry_srcu() macros") (v5.10).
> > This correctly associates the traversal with the SRCU lock and eliminates the
> > lockdep warnings.
> > 
> > Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > Acked-by: Kai Huang <kai.huang@intel.com>
> > ---
> 
> Ping
> 
> thanks
> 
> [Li,Rongqing] 
> 
> 
> 
> > Diff with v1: rewrite changelog
> > 
> >  arch/x86/kernel/cpu/sgx/encl.c | 12 ++++++++----
> > arch/x86/kernel/cpu/sgx/main.c |  3 ++-
> >  2 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index ac60ebd..91362d7 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -822,7 +822,8 @@ static struct sgx_encl_mm *sgx_encl_find_mm(struct
> > sgx_encl *encl,
> > 
> >  	idx = srcu_read_lock(&encl->srcu);
> > 
> > -	list_for_each_entry_rcu(tmp, &encl->mm_list, list) {
> > +	list_for_each_entry_srcu(tmp, &encl->mm_list, list,
> > +			srcu_read_lock_held(&encl->srcu)) {
> >  		if (tmp->mm == mm) {
> >  			encl_mm = tmp;
> >  			break;
> > @@ -933,7 +934,8 @@ const cpumask_t *sgx_encl_cpumask(struct sgx_encl
> > *encl)
> > 
> >  	idx = srcu_read_lock(&encl->srcu);
> > 
> > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > +	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
> > +			srcu_read_lock_held(&encl->srcu)) {
> >  		if (!mmget_not_zero(encl_mm->mm))
> >  			continue;
> > 
> > @@ -1018,7 +1020,8 @@ static struct mem_cgroup
> > *sgx_encl_get_mem_cgroup(struct sgx_encl *encl)
> >  	 */
> >  	idx = srcu_read_lock(&encl->srcu);
> > 
> > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > +	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
> > +			srcu_read_lock_held(&encl->srcu)) {
> >  		if (!mmget_not_zero(encl_mm->mm))
> >  			continue;
> > 
> > @@ -1212,7 +1215,8 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl,
> > unsigned long addr)
> > 
> >  		idx = srcu_read_lock(&encl->srcu);
> > 
> > -		list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > +		list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
> > +				srcu_read_lock_held(&encl->srcu)) {
> >  			if (!mmget_not_zero(encl_mm->mm))
> >  				continue;
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 38b7fd2..581e0c4 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -120,7 +120,8 @@ static bool sgx_reclaimer_age(struct sgx_epc_page
> > *epc_page)
> > 
> >  	idx = srcu_read_lock(&encl->srcu);
> > 
> > -	list_for_each_entry_rcu(encl_mm, &encl->mm_list, list) {
> > +	list_for_each_entry_srcu(encl_mm, &encl->mm_list, list,
> > +			srcu_read_lock_held(&encl->srcu)) {
> >  		if (!mmget_not_zero(encl_mm->mm))
> >  			continue;
> > 
> > --
> > 2.9.4
> 


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
