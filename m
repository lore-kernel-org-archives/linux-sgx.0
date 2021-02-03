Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F03C433E6
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Feb 2021 17:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0798C64E93
	for <linux-sgx@archiver.kernel.org>; Wed,  3 Feb 2021 17:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhBCRIs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Feb 2021 12:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhBCRIp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 3 Feb 2021 12:08:45 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1170DC0613ED
        for <linux-sgx@vger.kernel.org>; Wed,  3 Feb 2021 09:08:00 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t29so210591pfg.11
        for <linux-sgx@vger.kernel.org>; Wed, 03 Feb 2021 09:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G1iwSbTVj6QBQpGti6KeydgsQsfsoS1OzKLwdbvGTlg=;
        b=Y/iuW7ktUr9N60A9jncs5vg9Df3WAmp7Mz/GBlCJvytad9IsqzMFNSjX20mjDweX8t
         SfeM0TrXnWtmLpCKXNenztGoOffKRBKoUGnBVldUZalpPxA1xHp5D4h2tVagdxcmdF+H
         1QC9ns87ZGbm2a4Jc1Y43fqKAdDriiOZHZ+9MUipbLGb8jU4L85LwHxamry5Yu/yC8eO
         exvxIiB/wwGng0NBVRiVJlrH4+0tylVlHdKpD3JYORITsgUmbQu4qzyeqApdloFnRuFz
         cYTNSU8nE4/65pfz6TJssev82KTiljmL78AUr4aI7ttc6//FhQypp860FpBHC7ZCKanB
         /XQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G1iwSbTVj6QBQpGti6KeydgsQsfsoS1OzKLwdbvGTlg=;
        b=bnKBgo/UwECLutahlRJwcES09nrQTLiJNu1sLpU0cCfLY7hWs1Aj343d0A1vAUQ3ZP
         QgkaSl8QBoIa1LrwVK9ndPpGFpVl+xaEsMvwL4v3MllJvWIOrsrLvcI4xPJo8P0CeuGt
         3r6BLX8uyctJu3hOlwfefbwqwfh5JQSvukK2Lg7c0nf/XFO2i+Bu0PBYgITjs+jXqpQ+
         /qUNqfx3lRWFjlQxWwBDdDECfs+PYP5f1VJRxND48AnKwgXNuvtSFMnIodgJgn6Buaeh
         G9fLuUuIqBXM8NBTdS0Bniz7K5J7Q9fEBw60JPtR2BYQOCBYf5eab00+gDdwVPeFeShj
         6N/Q==
X-Gm-Message-State: AOAM533Av34HBddDWvcz8/pFrrfFAF/gThuqQfXTmZPrSfRDMr3tpCbU
        sWRK0URTL0pCm8RgygTfz0CpJct/KGKGBQ==
X-Google-Smtp-Source: ABdhPJxCuXMUJNpQmsJXTGvIkc9S/pMWMsa405DX5HjgAscsYcnCDDnULytXFdhfFVDsbihZnILAyw==
X-Received: by 2002:a63:e109:: with SMTP id z9mr4715327pgh.5.1612372079463;
        Wed, 03 Feb 2021 09:07:59 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id p8sm3258411pgi.21.2021.02.03.09.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 09:07:58 -0800 (PST)
Date:   Wed, 3 Feb 2021 09:07:52 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YBrYaFxo6S79l0kA@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
 <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
 <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
 <YBn+DBXJgPmA1iED@google.com>
 <20210203221110.c50ec5cd50a77d269c3656bd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210203221110.c50ec5cd50a77d269c3656bd@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 03, 2021, Kai Huang wrote:
> On Tue, 2 Feb 2021 17:36:12 -0800 Sean Christopherson wrote:
> > On Wed, Feb 03, 2021, Edgecombe, Rick P wrote:
> > > On Tue, 2021-01-26 at 22:31 +1300, Kai Huang wrote:
> > > > +       /*
> > > > +        * Verify alignment early.  This conveniently avoids having
> > > > to worry
> > > > +        * about page splits on userspace addresses.
> > > > +        */
> > > > +       if (!IS_ALIGNED(pageinfo.metadata, 64) ||
> > > > +           !IS_ALIGNED(pageinfo.contents, 4096)) {
> > > > +               kvm_inject_gp(vcpu, 0);
> > > > +               return 1;
> > > > +       }
> > > > +
> > > > +       /*
> > > > +        * Translate the SECINFO, SOURCE and SECS pointers from GVA
> > > > to GPA.
> > > > +        * Resume the guest on failure to inject a #PF.
> > > > +        */
> > > > +       if (sgx_gva_to_gpa(vcpu, pageinfo.metadata, false,
> > > > &metadata_gpa) ||
> > > > +           sgx_gva_to_gpa(vcpu, pageinfo.contents, false,
> > > > &contents_gpa) ||
> > > > +           sgx_gva_to_gpa(vcpu, secs_gva, true, &secs_gpa))
> > > > +               return 1;
> > > > +
> > > 
> > > Do pageinfo.metadata and pageinfo.contents need cannonical checks here?
> > 
> > Bugger, yes.  So much boilerplate needed in this code :-/
> > 
> > Maybe add yet another helper to do alignment+canonical checks, up where the
> > IS_ALIGNED() calls are?
> 
> sgx_get_encls_gva() already does canonical check. Couldn't we just use it?

After rereading the SDM for the bajillionth time, yes, these should indeed use
sgx_get_encls_gva().  Originally I was thinking they were linear addresses, but
they are effective addresses that use DS, i.e. not using the helper to avoid the
DS.base adjustment for 32-bit mode was also wrong.

> For instance:
> 
> 	if (sgx_get_encls_gva(vcpu, pageinfo.metadata, 64, 64 &metadata_gva) ||
> 	    sgx_get_encls_gva(vcpu, pageinfo.contents, 4096, 4096,
>                              &contents_gva))
> 		return 1;
