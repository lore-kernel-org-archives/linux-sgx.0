Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10E1C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97B2A20731
	for <linux-sgx@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313373AbhAZXDm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731426AbhAZRFZ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 Jan 2021 12:05:25 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03071C061788
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 09:00:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i63so10761604pfg.7
        for <linux-sgx@vger.kernel.org>; Tue, 26 Jan 2021 09:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ENlLmc+JejdwJwWT2OL+d2JHDx3OTLzS/BlF7JGq2nA=;
        b=aZ/ShnW8eg0eJ5zhC4gY7+YObNwS5lRBPfbAGJ4ULjVLsF55wBXe9n8giN7CT2SM/S
         /DhG85ScJiXlL0JBakWStEdk5M3H2FD/nemAq/AIG+jo2/oEzN/nFlhqJHdRvGmX5ckg
         f//nXQd0qCvuQymR64nsDY27lBtZBNl1KEQ5mE47uORe6pr9IRdvs6ewoYwBbiEzzzB5
         I4t9ku9OHD8eAp6XM9e87sB3533UzU8oa+xG5YS+i0xD3Wp2LPVifKg73pICaNyKzMma
         OE+Ps9wJU+TuEfyzftqI/wrZ6KVCmQihFVoNg8oo3Ng6DqQCbCpdLgADSyKcrgU5TlRS
         66CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ENlLmc+JejdwJwWT2OL+d2JHDx3OTLzS/BlF7JGq2nA=;
        b=Qx/TWQyOcysPw8+/HQvWYzL5otvTWOlwqirxSJNu3waqSSAHJSCaTTXnTl1i4GquV/
         fVMlktVo1F/tzEwVYrBXXiCBvG26qv0seoYGq5ZfpsAhJ51aTpGjIOsTnlSZ+8aAbCEZ
         zKGAoR7IfRXIXwB09SWcFrA1/N2oOapSIor2dgTCNuYITTUUJ+G3eUvKSSFhzgD5eHRO
         pjwoEykamulDWU7x8x7hDcrrTFI2CCou/8XtDtheg8YTxdJzyJgTvJLYMZkIw/EyKmY8
         5JJSRG1FErWdt3x/zZlepqHjdy+MSWwq1w9GdQe5YP5TT2LsJ9K4D0uMsRwpCvkZ5caq
         fxJg==
X-Gm-Message-State: AOAM531gcBJqmrazAdLa9yVh/KDeo+GPOPittFk02Lg13Qp03iFdPsZ8
        BafDWsyw6XVwwEcZ2NXuXhwJSw==
X-Google-Smtp-Source: ABdhPJyWOBKzyzUyfMtkAbOdRuR4zb43p89ImjgpolqyL65mgDafFCN9gIbSLho2Ez7hZxhmbwoDxQ==
X-Received: by 2002:a65:5283:: with SMTP id y3mr6502558pgp.174.1611680453424;
        Tue, 26 Jan 2021 09:00:53 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a2sm5382885pgq.94.2021.01.26.09.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 09:00:52 -0800 (PST)
Date:   Tue, 26 Jan 2021 09:00:45 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [RFC PATCH v3 07/27] x86/cpu/intel: Allow SGX virtualization
 without Launch Control support
Message-ID: <YBBKvecRXYclMnpH@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <ae05882235e61fd8e7a56e37b0d9c044781bd767.1611634586.git.kai.huang@intel.com>
 <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23b9893-015b-a9cb-de93-1a4978981e83@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 26, 2021, Dave Hansen wrote:
> > -	enable_sgx = cpu_has(c, X86_FEATURE_SGX) &&
> > -		     cpu_has(c, X86_FEATURE_SGX_LC) &&
> > -		     IS_ENABLED(CONFIG_X86_SGX);
> > +	enable_sgx_any = cpu_has(c, X86_FEATURE_SGX) &&
> > +			 cpu_has(c, X86_FEATURE_SGX1) &&
> > +			 IS_ENABLED(CONFIG_X86_SGX);
> 
> The X86_FEATURE_SGX1 check seems to have snuck in here.  Why?

It's a best effort check to handle the scenario where SGX is enabled by BIOS,
but was disabled by hardware in response to a machine check bank being disabled.
Adding a check on SGX1 should be in a different patch.  I thought we had a
dicscussion about why the check was omitted in the merge of bare metal support,
but I can't find any such thread.

> > +	enable_sgx_driver = enable_sgx_any &&
> > +			    cpu_has(c, X86_FEATURE_SGX_LC);
> > +	enable_sgx_kvm = enable_sgx_any && enable_vmx &&
> > +			  IS_ENABLED(CONFIG_X86_SGX_KVM);
> >  
> >  	if (msr & FEAT_CTL_LOCKED)
> >  		goto update_caps;
> > @@ -136,15 +146,18 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	 * i.e. KVM is enabled, to avoid unnecessarily adding an attack vector
> >  	 * for the kernel, e.g. using VMX to hide malicious code.
> >  	 */
> > -	if (cpu_has(c, X86_FEATURE_VMX) && IS_ENABLED(CONFIG_KVM_INTEL)) {
> > +	if (enable_vmx) {
> >  		msr |= FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
> >  
> >  		if (tboot)
> >  			msr |= FEAT_CTL_VMX_ENABLED_INSIDE_SMX;
> >  	}
> >  
> > -	if (enable_sgx)
> > -		msr |= FEAT_CTL_SGX_ENABLED | FEAT_CTL_SGX_LC_ENABLED;
> > +	if (enable_sgx_kvm || enable_sgx_driver) {
> > +		msr |= FEAT_CTL_SGX_ENABLED;
> > +		if (enable_sgx_driver)
> > +			msr |= FEAT_CTL_SGX_LC_ENABLED;
> > +	}
> >  
> >  	wrmsrl(MSR_IA32_FEAT_CTL, msr);
> >  
> > @@ -167,10 +180,29 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
> >  	}
> >  
> >  update_sgx:
> > -	if (!(msr & FEAT_CTL_SGX_ENABLED) ||
> > -	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
> > -		if (enable_sgx)
> > -			pr_err_once("SGX disabled by BIOS\n");
> > +	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
> > +		if (enable_sgx_kvm || enable_sgx_driver)
> > +			pr_err_once("SGX disabled by BIOS.\n");
> >  		clear_cpu_cap(c, X86_FEATURE_SGX);
> > +		return;
> > +	}
> 
> 
> Isn't there a pr_fmt here already?  Won't these just look like:
> 
> 	sgx: SGX disabled by BIOS.
> 
> That seems a bit silly.

Eh, I like the explicit "SGX" to clarify that the hardware feature was disabled.
