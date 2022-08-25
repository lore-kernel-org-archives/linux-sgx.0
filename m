Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38566C28D13
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Aug 2022 15:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiHYPTY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Aug 2022 11:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbiHYPTX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 25 Aug 2022 11:19:23 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0524B8A7F
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 08:19:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id jm11so18779174plb.13
        for <linux-sgx@vger.kernel.org>; Thu, 25 Aug 2022 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=0cKABFUN+wnQcetiBFS+ZWvGWfmSSFXH2Vy7bIP70To=;
        b=n4VTCk+hi4atd4sl9xX8mkpWnVRvlZsWhrI7z1ws5nNsnjD5c/UZmgA62xHwFEBC77
         QH/tB5H1R5AOYoiEK7tFDt17r2gpvL1Y/ulfhtQGJ1GkwGBFB+fQX5Tm+zrr+/EhlcLE
         C23Yyjog5FobgJ7Dj8N9uHobenLy9t7bP7TjQbOTJtu8HGF9d8LrPm15wls7xzCuZ/79
         IOTP508EjxCfVszWalUtem+LafKgjjJ9vzKpITgkTbH8VuXCou/ccTkTotHY19aKr+F5
         r8vKvV04QJmuZghSxWCBpuTIYro+juj2XzlNZ5r7Ehv9dyGBLf9EFNkTH7TM9nR08iJJ
         iiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0cKABFUN+wnQcetiBFS+ZWvGWfmSSFXH2Vy7bIP70To=;
        b=CbHjlfAvAZPDbV/II8A3dkpQOTrZ/4pNdLHvUHX0+4QecBS73lJog9jeBRdQC0XpzH
         yLK1dmdlbhttufX1a86kf7RxV/9ojCQk+1cY4LTmosVaa53zAg+C+BzlrSBCENeMTqTh
         0xb/rWcs36v1R/Qo5A3Ngvl9cJ1vdy2a8wBeLCDjR+/huI3bEVsghDIGrKqzq34Fszw6
         LY8NmRmxLaD/fRPaAHhQGCZ2/PYcMCqzgmX28p43vZwUjSNeS+Gdfr0EQt4KF1qgeAMo
         cK9eWF/a7Th2JjbX4Q2RCePc6RnWsqOtOasF/DUdyAjvKO+/lXo1bK1GC62FMn0uUteD
         ROSg==
X-Gm-Message-State: ACgBeo27Q3msaVFNjZ48QEuXm6V91FNQ2eOkXx/PhBAwm9uxU92XreST
        jgOPvY4BWETXX58hyA5ZHPR84w==
X-Google-Smtp-Source: AA6agR4ECS4oI+ONI4GnXK4C2r5ILO0emxVW6B//31Dq/MYub15KoTEv287azdYa76yYflAVM1Wq2g==
X-Received: by 2002:a17:902:db11:b0:16f:342:a439 with SMTP id m17-20020a170902db1100b0016f0342a439mr4140450plx.13.1661440761992;
        Thu, 25 Aug 2022 08:19:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o17-20020a17090a9f9100b001f51903e03fsm3636235pjp.32.2022.08.25.08.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:19:21 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:19:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YweS9QRqaOgH7pNW@google.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwbrywL9S+XlPzaX@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 25, 2022, Jarkko Sakkinen wrote:
> Nit: shouldn't be this be x86/kvm?

Heh, no, because x86/kvm is the scope for Linux running as a KVM guest, i.e. for
changes to arch/x86/kernel/kvm.c.

But yeah, "KVM: x86:" or maybe even "KVM: VMX:" would be preferable given that all
of the meaningful changes are KVM specific.

> On Thu, Aug 18, 2022 at 02:38:29PM +1200, Kai Huang wrote:
> > The new Asynchronous Exit (AEX) notification mechanism (AEX-notify)
> > allows one enclave to receive a notification in the ERESUME after the
> > enclave exit due to an AEX.  EDECCSSA is a new SGX user leaf function
> > (ENCLU[EDECCSSA]) to facilitate the AEX notification handling.  The new
> > EDECCSSA is enumerated via CPUID(EAX=0x12,ECX=0x0):EAX[11].
> > 
> > Besides Allowing reporting the new AEX-notify attribute to KVM guests,
> > also allow reporting the new EDECCSSA user leaf function to KVM guests
> > so the guest can fully utilize the AEX-notify mechanism.
> > 
> > Similar to existing X86_FEATURE_SGX1 and X86_FEATURE_SGX2, introduce a
> > new scattered X86_FEATURE_SGX_EDECCSSA bit for the new EDECCSSA, and
> > report it in KVM's supported CPUIDs so the userspace hypervisor (i.e.
> > Qemu) can enable it for the guest.

Silly nit, but I'd prefer to leave off the "so the userspace hypervisor ... can
enable it for the guest".  Userspace doesn't actually need to wait for KVM enabling.
As noted below, KVM doesn't need to do anything extra, and KVM _can't_ prevent the
guest from using EDECCSSA.

> > Note there's no additional enabling work required to allow guest to use
> > the new EDECCSSA.  KVM is not able to trap ENCLU anyway.

And maybe call out that the KVM "enabling" is not strictly necessary?  And note
that there's a virtualization hole?  E.g.

  Note, no additional KVM enabling is required to allow the guest to use
  EDECCSSA, it's impossible to trap ENCLU (without completely preventing the
  guest from using SGX).  Advertise EDECCSSA as supported purely so that
  userspace doesn't need to special case EDECCSSA, i.e. doesn't need to
  manually check host CPUID.

  The inability to trap ENCLU also means that KVM can't prevent the guest
  from using EDECCSSA, but that virtualization hole is benign as far as KVM
  is concerned.  EDECCSSA is simply a fancy way to modify internal enclave
  state.

> > More background about how do AEX-notify and EDECCSSA work:
> > 
> > SGX maintains a Current State Save Area Frame (CSSA) for each enclave
> > thread.  When AEX happens, the enclave thread context is saved to the
> > CSSA and the CSSA is increased by 1.  For a normal ERESUME which doesn't
> > deliver AEX notification, it restores the saved thread context from the
> > previously saved SSA and decreases the CSSA.  If AEX-notify is enabled
> > for one enclave, the ERESUME acts differently.  Instead of restoring the
> > saved thread context and decreasing the CSSA, it acts like EENTER which
> > doesn't decrease the CSSA but establishes a clean slate thread context
> > using the CSSA for the enclave to handle the notification.  After some
> > handling, the enclave must discard the "new-established" SSA and switch
> > back to the previously saved SSA (upon AEX).  Otherwise, the enclave
> > will run out of SSA space upon further AEXs and eventually fail to run.
> > 
> > To solve this problem, the new EDECCSSA essentially decreases the CSSA.
> > It can be used by the enclave notification handler to switch back to the
> > previous saved SSA when needed, i.e. after it handles the notification.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > 
> > Hi Dave,
> > 
> > This patch, along with your patch to expose AEX-notify attribute bit to
> > guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> > Feel free to merge this patch.

Dave, any objection to taking this through the KVM tree?
