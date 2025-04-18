Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A34E1552EB
	for <linux-sgx@vger.kernel.org>; Fri, 18 Apr 2025 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744985931; cv=none; b=odpi5n61itEwFbLxuWVwkZxg5JSnZ8mH2O+dqVTLMX8I2IH8dnR+dohxb0A/3sh7ds0SQvHjcFShaS15Ws3S+fp7s/TofHj630L/YgXFpQHMXd63PEazV1ODOvpfMY0znaz7f7kv7YFKykU5Np8k4sNCPSXYzBDKI1eFzFpg4UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744985931; c=relaxed/simple;
	bh=pUkjD1FghkHBdydJuYX2OPu84OoLeZjhEfD2QWq8NWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pRsH88b3iVOIk/o1D0vo+/z3aMI1EsDK2nj46vC0BSbCUNgMECvDJB61oxYoKHVyCGn4PYWfeUcgfwl0CMbTp6/EDhTXcvAlFO7WsrBYfK6MesDRCmvY5TP7sGV1eXWm2gYYGBdgnH4HxYNWdRXvnvkWT7lkrOOi6GEllHKCYCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aGJprITQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aGJprITQ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3087a703066so788203a91.0
        for <linux-sgx@vger.kernel.org>; Fri, 18 Apr 2025 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744985929; x=1745590729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyKpHdHCd98xvNXzYgyo/Cil2h2Uc+7axnGj8AZOXY4=;
        b=aGJprITQa2ufvXyvemQemmkUfiF1cSKvZhW7W6oezHhDN4M00c4vO2/Smy1Kcn5Oex
         DCHBgor+5I/kBqpdCdkClhrDkwF6TSgK7e9/vwIjJU1DBnuQSi/lJq5bUQ/86mwxqK6W
         ITNdKqIEyG0NIFwJIskhQEpUdVVVtYI3Ga0EDvMjcfK7JXHUrFq8Ct6BTTmnBamm5Bpj
         hUS2lUD5pE7xKg454RLY5UT3pNkzZJBNyE2SGL7//BpyNnJOaQry1YHBZd4o8P9sPGgo
         1V3wTJVjMVHLjiVq6SokPsDtSvC1vE0bg/jyAq+0tatx9dDQU6PslsDvvDdZX2cRJ3qJ
         joJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744985929; x=1745590729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VyKpHdHCd98xvNXzYgyo/Cil2h2Uc+7axnGj8AZOXY4=;
        b=asz+RV2fP836X27Tp3uxyXINaCf7rQ1n8kXSqjm4bbL2m8sE/C3+iAT4q2sq1rUKiO
         lEkxgnuyEHobX/pLdo39K2L0XGwo+dzKKkhDPBmhEQW6y1DkbnGFUMKgx+KXUHR7HOEy
         B2S4rbkmgy70ZOAWl8eSzofd7SaORsl+MYch6LiJcWXg1IQ2e7uTTpv9WLRh/nuC9503
         BnGZa1pTNUwm+rgrRmamwLKbicq7Bc20tox0ENsk+8WvbC9Q/BIUAowCxv5KT/PNIr4N
         EsdfIpOhBQWjFAqKwmvzrrJk/Z6n5NJ2UTBu+IRQcVSRRz2OjDVMZJktmjzEK9y0unbr
         75EQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYtvc96xGHr/5VWlQYGJgO1HtINqKPMwH/+PLL9xbLcnL0xmiOut+4uvydIkZBGwMvxYDy25Sb5SE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/VTUJmU2+fNMydsgiyQjD5W6EYOAgfwiuvdHLEzx218i3r09L
	q63FypoGzZM2fnHqH8gOi4iC+ZIsiNgILqvUpYVNKp2R9549faGBv/M2WIAtpliDHXqyqkxpyZ5
	Zvw==
X-Google-Smtp-Source: AGHT+IEiGSslixzn2GvqhbUzQFd3uzt4D4erY5NFbgr7oLyfFseBn9Ti3SeLm9HiYvGrGLgi01kpDWgv72s=
X-Received: from pjbsz11.prod.google.com ([2002:a17:90b:2d4b:b0:2f9:c349:2f84])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2703:b0:2ff:7b28:a51a
 with SMTP id 98e67ed59e1d1-3087bb6960amr4998384a91.17.1744985929401; Fri, 18
 Apr 2025 07:18:49 -0700 (PDT)
Date: Fri, 18 Apr 2025 07:18:46 -0700
In-Reply-To: <6bbfb38a0cd66af3d3562a82adac835316b1f4e5.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com> <11f7e006073d2a4fa8fd6c609024a69ed40af9d6.camel@intel.com>
 <DM8PR11MB5750C80ED4AB80C696F581EFE7BD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <6bbfb38a0cd66af3d3562a82adac835316b1f4e5.camel@intel.com>
Message-ID: <aAJfJ38wt2bnguhg@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, Vincent Scarlata <vincent.r.scarlata@intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Chong Cai <chongc@google.com>, 
	Asit K Mallick <asit.k.mallick@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, Scott Raynor <scott.raynor@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 17, 2025, Kai Huang wrote:
> I think the sgx_updatesvn() should just return true when EUPDATESVN returns 0 or
> SGX_NO_UPDATE, and return false for all other error codes.  And it should
> ENCLS_WARN() for all other error codes, except SGX_INSUFFICIENT_ENTROPY because
> it can still legally happen.
> 
> Something like:
> 
> 	do {
> 		ret = __eupdatesvn();
> 		if (ret != SGX_INSUFFICIENT_ENTROPY)
> 			break;
> 	} while (--retry);

This can be:

	do {
		ret = __eupdatesvn();
	} while (ret == SGX_INSUFFICIENT_ENTROPY && --retry)

To make it super obvious that retry is only relevant to lack of entropy.

> 	if (!ret || ret == SGX_NO_UPDATE) {
> 		/*
> 		 * SVN successfully updated, or it was already up-to-date.
> 		 * Let users know when the update was successful.
> 		 */
> 		if (!ret)
> 			pr_info("SVN updated successfully\n");
> 		return true;

Returning true/false is confusing since the vast majority of the SGX code uses
'0' for success.  A lot of cleverness went into splicing SGX's error codes into
the kernel's -ernno; it would be a shame to ignore that :-)

E.g. this looks wrong at first (and second glance)

			ret = sgx_updatesvn();
			if (!ret) {
				/*
				 * sgx_updatesvn() returned unknown error, smth
				 * must be broken, do not allocate a page from EPC
				 */
				spin_unlock(&sgx_epc_eupdatesvn_lock);
				spin_unlock(&node->lock);
				return NULL;
			}

> 	}
> 
> 	/*
> 	 * EUPDATESVN was called when EPC is empty, all other error
> 	 * codes are unexcepted except running out of entropy.
> 	 */
> 	if (ret != SGX_INSUFFICIENT_ENTROPY)
> 		ENCLS_WARN(ret, "EUPDATESVN");
> 
> 	return false;
> 		
> 
> In __sgx_alloc_epc_page_from_node(), it should fail to allocate EPC page and
> return -ENOMEM when sgx_updatesvn() returns false.  We should only allow EPC to

No, it should return a meaningful error code, not -ENOMEM.  And if that's the
behavior you want, then __sgx_alloc_epc_page() should be updated to bail immediately.
The current code assuming -ENOMEM is the only failure scenario:

	do {
		page = __sgx_alloc_epc_page_from_node(nid);
		if (page)
			return page;

		nid = next_node_in(nid, sgx_numa_mask);
	} while (nid != nid_start);

That should be something like:

	do {
		page = __sgx_alloc_epc_page_from_node(nid);
		if (!IS_ERR(page) || PTR_ERR(page) != -ENOMEM)
			return page;

		nid = next_node_in(nid, sgx_numa_mask);
	} while (nid != nid_start);

> be allocated when we know the SVN is already up-to-date.
> 
> Any further call of EPC allocation will trigger sgx_updatesvn() again.  If it
> was failed due to unexpected error, then it should continue to fail,
> guaranteeing "sgx_alloc_epc_page() return consistently -ENOMEM, if the
> unexpected happens".  If it was failed due to running out of entropy, it then
> may fail again, or it will just succeed and then SGX can continue to work.


Side topic, the function comment for __sgx_alloc_epc_page() is stale/wrong.  It
returns ERR_PTR(-ENOMEM), not NULL, on failure.

/**
 * __sgx_alloc_epc_page() - Allocate an EPC page
 *
 * Iterate through NUMA nodes and reserve ia free EPC page to the caller. Start
 * from the NUMA node, where the caller is executing.
 *
 * Return:
 * - an EPC page:	A borrowed EPC pages were available.
 * - NULL:		Out of EPC pages.
 */
