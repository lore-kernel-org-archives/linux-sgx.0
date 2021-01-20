Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3072BC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02633233F7
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbhATQn6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Jan 2021 11:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391610AbhATQkQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 20 Jan 2021 11:40:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A686C061757
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:39:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b8so12786940plh.12
        for <linux-sgx@vger.kernel.org>; Wed, 20 Jan 2021 08:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nuK0zgKpAn8bzQ1mtmeXEwK3kY3X8JH630/Yem/GinQ=;
        b=gIXzr+069d/0fSiLThZbkPQeXmsQRTA6DjfqW/10j2gExSlk9huiiDDtiCOiN/Tu5M
         rns0U/Wr07wrfCqvQZOFkv/zvBv93JdbzykMYcYj+pGumuLDlMG1Q0/lWcdEMCS9f2Q2
         uotpqsKxh+CgYeYzZbcM3pugbyYc3Yl/RERF71wHJziT0kzZFIr4zKzjEGrR0srj2hTW
         mWjIxXPdSACvzeroplr2kVvNz0m7+btstdaOKt8VT78blNBNQNl3+RaCyYAuK5PXzCqW
         P66oyaxTK8OVJrDEeUQtWv9p3V1sIXxxtiI35cOZWF6o87ParWHAVYwYct6on+Dt3qhR
         nSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nuK0zgKpAn8bzQ1mtmeXEwK3kY3X8JH630/Yem/GinQ=;
        b=ldJFGuNV4nWTpYubDuDb5D28uM4CbD6PAA202+JvRk3/X9yHs12t+zXzcReXKJFiGl
         ro27PLnNOoB7ngKW5/dLtA+DfZ82+GU9v4ca46bzmZP8nrUvynmOU8QH50YrnL74qQpb
         J/wdyPsi2BrPwySkOBMMjKV67xL5lXGr12ZHXDogiM5xcveIox7/3X+eulq8odWx75nU
         dggjfL28o0HqTVEGSZtQ2Op+ewDFLdY+YznDHscph+5Py5VhLo0+dL7G86zSYCctVOWJ
         yI8LtcFYi5H8VN2f5kkdwzyRN/fE8nX/P43yKAVUP5pzCKRkVGbN6y8hxPLVzHwePXft
         38Rw==
X-Gm-Message-State: AOAM5312DHsTPpsWxTLpoZVsv6mi5KfTb0+eE2Pi49kwJG0PXyLdhbgd
        sU3WwgfGBBBWuPblklNMrE+xyg==
X-Google-Smtp-Source: ABdhPJxDnTAJfxEaIlpQNTYS5GtZPsaetfRE5nmAw+H2XkASTdS3RyZDqs+FHwbl9QlVipCd8xoYEw==
X-Received: by 2002:a17:902:9a03:b029:dc:31af:8dc2 with SMTP id v3-20020a1709029a03b02900dc31af8dc2mr10774139plp.39.1611160773822;
        Wed, 20 Jan 2021 08:39:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id fv19sm2926134pjb.20.2021.01.20.08.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 08:39:33 -0800 (PST)
Date:   Wed, 20 Jan 2021 08:39:26 -0800
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
Message-ID: <YAhcvqXNxq0ALCyO@google.com>
References: <cover.1610935432.git.kai.huang@intel.com>
 <72e2f0e0fb28af55cb11f259eb5bc9e034fb705c.1610935432.git.kai.huang@intel.com>
 <YAg7vzevfw5iL9kN@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAg7vzevfw5iL9kN@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jan 20, 2021, Jarkko Sakkinen wrote:
> On Mon, Jan 18, 2021 at 04:28:26PM +1300, Kai Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
> > full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
> > bits 15:0, and single-bit modifiers in bits 31:16.
> > 
> > Historically, KVM has only had to worry about handling the "failed
> > VM-Entry" modifier, which could only be set in very specific flows and
> > required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
> > bit was a somewhat viable approach.  But even with only a single bit to
> > worry about, KVM has had several bugs related to comparing a basic exit
> > reason against the full exit reason store in vcpu_vmx.
> > 
> > Upcoming Intel features, e.g. SGX, will add new modifier bits that can
> > be set on more or less any VM-Exit, as opposed to the significantly more
> > restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
> > flows isn't scalable.  Tracking exit reason in a union forces code to
> > explicitly choose between consuming the full exit reason and the basic
> > exit, and is a convenient way to document and access the modifiers.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++---------
> >  arch/x86/kvm/vmx/vmx.c    | 68 ++++++++++++++++++++-------------------
> >  arch/x86/kvm/vmx/vmx.h    | 25 +++++++++++++-
> >  3 files changed, 86 insertions(+), 49 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 0fbb46990dfc..f112c2482887 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3311,7 +3311,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
> >  	enum vm_entry_failure_code entry_failure_code;
> >  	bool evaluate_pending_interrupts;
> > -	u32 exit_reason, failed_index;
> > +	u32 failed_index;
> > +	union vmx_exit_reason exit_reason = {
> > +		.basic = -1,
> > +		.failed_vmentry = 1,
> > +	};
> 
> Instead, put this declaration to the correct place, following the
> reverse christmas tree ordering:
> 
>         union vmx_exit_reason exit_reason = {};
> 
> And after declarations:
> 
>         exit_reason.basic = -1;
>         exit_reason.failed_vmentry = 1;
> 
> More pleasing for the eye.

I disagree (obviously, since I wrote the patch).  Initializing the fields to
their respective values is a critical, but subtle, aspect of this code.  Making
the code stand out via explicit initialization is a good thing, and we really
don't want any possibility of code touching exit_reason before it is initialized.
