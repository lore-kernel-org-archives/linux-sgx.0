Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E53C433E9
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 16:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6264A23A59
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jan 2021 16:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbhAUQfF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Jan 2021 11:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732624AbhAUQeb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Jan 2021 11:34:31 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998B7C061786
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jan 2021 08:33:51 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id n7so1701144pgg.2
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jan 2021 08:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X+t7xR7tyEcXG4BO7PJTLqhUyVQaz5DDSBnf2PrL/nI=;
        b=h0OcGN4YIxE6sMTc9bbCaLvNg2aM5EWSgRQcee2Is1A6sx7464yb36gSDPdZw0/zRe
         ri6xDyydJYJNx6bx+B92IATXKm0Y1fzMy1NsQ4VOrD10va1vxyG7GE3ywJWttwfjTsoy
         rFhFKVTkm423z129/Ho1VRFqzRyefIPJpCkcgkI8mRaexhNptKDK/UeZ2xhBQrqCRf66
         SwCFtsUyLm6JngRLrUHNKgYnjlLL1q3DwUhT+9rbhWUtoaT5QdJILgBjI0BtUww5vuxj
         K07sGiZ4wJ1FYuJ1rGjQZpK7MK0udfFVCxfc/FPCK7ohn5W1T7Iy4qKX+Eqy9ILyjL+G
         AT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X+t7xR7tyEcXG4BO7PJTLqhUyVQaz5DDSBnf2PrL/nI=;
        b=pVB1QbNS+/9gQLFXTsirOWAkWrxTbTE2hplLFJukJlU67UcxXaEF9QJXbVnsUyPjPV
         AmH2FBejvRWGN13UiHS6q/ogNW9jHpkPtlthsTCgXbL7UUdLhixWlyej2A/exFm4s6On
         X57xKGapb3ISzRm5wsWN4VHM8IOnUDdislhDqvtj0akqQEVCy/uzF0qyMiQ1WdpWi7KJ
         aO7rr+Cv/Wh5c18I6n2hqkThJdiJzUJtOY6vNbw7KOa+dL9mHCUjMqNt2P4LEpZVaeXe
         ueW7egFlu4HFWEGj8da9DNSEsE5nxQawc4rZFmmo7BP4FmXH14KdZJFdQR3Ap3NxXiWp
         VD9g==
X-Gm-Message-State: AOAM532+ESSO3bD3Htf5pe/nm09N2ORzb+v5vGUqCaF2JnB/NVJN9TQ5
        2oEixFoBMLcxQKrx/eUr89q84S5VTIWR1w==
X-Google-Smtp-Source: ABdhPJxvRI5mxPw7f28/ltKkO2cdfjerbSpq0FoPFmCNKZTX3D2wcTvXB/aNsyz8ueGv9pBpXwDFlA==
X-Received: by 2002:a62:2aca:0:b029:1bb:4349:f889 with SMTP id q193-20020a622aca0000b02901bb4349f889mr279548pfq.26.1611246830897;
        Thu, 21 Jan 2021 08:33:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w192sm6116401pff.181.2021.01.21.08.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:33:50 -0800 (PST)
Date:   Thu, 21 Jan 2021 08:33:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [RFC PATCH v2 15/26] KVM: VMX: Convert vcpu_vmx.exit_reason to a
 union
Message-ID: <YAms5375BLAp/x1W@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
 <YAg7vzevfw5iL9kN@kernel.org>
 <YAhcvqXNxq0ALCyO@google.com>
 <YAjPC5VTiyO3XFsJ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAjPC5VTiyO3XFsJ@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 21, 2021, Jarkko Sakkinen wrote:
> On Wed, Jan 20, 2021 at 08:39:26AM -0800, Sean Christopherson wrote:
> > On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> > > On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
> > > >  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
> > > >  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
> > > >  3 files changed, 86 insertions(+), 49 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 0fbb46990dfc..f112c2482887 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > > >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> > > >  	enum vm_entry_failure_code entry_failure_code;
> > > >  	bool evaluate_pending_interrupts;
> > > > -	u32 exit_reason, failed_index;
> > > > +	u32 failed_index;
> > > > +	union vmx_exit_reason exit_reason = {
> > > > +		.basic = -1,
> > > > +		.failed_vmentry = 1,
> > > > +	};
> > > 
> > > Instead, put this declaration to the correct place, following the
> > > reverse christmas tree ordering:
> > > 
> > >         union vmx_exit_reason exit_reason = {};
> > > 
> > > And after declarations:
> > > 
> > >         exit_reason.basic = -1;
> > >         exit_reason.failed_vmentry = 1;
> > > 
> > > More pleasing for the eye.
> > 
> > I disagree (obviously, since I wrote the patch).  Initializing the fields to
> > their respective values is a critical, but subtle, aspect of this code.  Making
> > the code stand out via explicit initialization is a good thing, and we really
> > don't want any possibility of code touching exit_reason before it is initialized.
> 
> The struct does get initialized to zero, and fields get initialized
> to their respective values. What is the critical aspect that is gone?
> I'm not following.

Setting exit_reason.failed_vmentry from time zero.  This code should never
synthesize a nested VM-Exit with failed_vmentry=0.  There have been bugs around
the exit_reason in this code in the past, I strongly prefer to not have any
window where exit_reason has the "wrong" value.
