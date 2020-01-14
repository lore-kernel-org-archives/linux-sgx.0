Return-Path: <SRS0=lkUJ=3D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UPPERCASE_50_75,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9EBC33CB1
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 09:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D9CD2187F
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jan 2020 09:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="pgBB9y3O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgANJj0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jan 2020 04:39:26 -0500
Received: from mail.skyhub.de ([5.9.137.197]:47996 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgANJj0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jan 2020 04:39:26 -0500
Received: from zn.tnic (p200300EC2F0C7700ADC3CAC9BB95AB92.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:7700:adc3:cac9:bb95:ab92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CD8661EC0C76;
        Tue, 14 Jan 2020 10:39:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1578994765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=IZNV9YLr/3zZV8OG+FOVaVXrNs5YzPljaR6TGV7izxU=;
        b=pgBB9y3OqqB2JLBkpzhCOmYBaxZYEpvVuRc3DI1CmAoh3PPj6myMC1iIUzLyeQ6SVfG/dX
        CgY9DQ7+I+QfA7PIvu9CIfK5JEdGtJI/xca5T0moHGtrOxZS4k8IOQCLlexas7cPOAIl8K
        Hmh/kus6honCduPLSFsu5/6JT/3KVls=
Date:   Tue, 14 Jan 2020 10:39:21 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: v25-rc1
Message-ID: <20200114093921.GC31032@zn.tnic>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
 <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
 <20200113140407.GI13310@zn.tnic>
 <21550b11-3545-387c-f367-051919a1e193@redhat.com>
 <20200113160748.GJ13310@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200113160748.GJ13310@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 13, 2020 at 05:07:48PM +0100, Borislav Petkov wrote:
> On Mon, Jan 13, 2020 at 04:20:35PM +0100, Paolo Bonzini wrote:
> > Put them in too, it's even simpler.
> 
> /me brews a fresh coffee and gets crackin'.

JFYI: there'll be a merge conflict, below is me merging into linux-next
from today.

Also, don't forget to fixup CPU_BASED_USE_TSC_OFFSETTING with "TT" since
you hav                                                                e

  5e3d394fdd9e ("KVM: VMX: Fix the spelling of CPU_BASED_USE_TSC_OFFSETTING")

in your tree but this tree still has:

+ #define CPU_BASED_USE_TSC_OFFSETING             VMCS_CONTROL_BIT(TSC_OFFSETTING)

Lemme know if there's something else I should do.

Thx.

---
diff --cc arch/x86/include/asm/vmx.h
index d716fe938fc0,9fbba31be825..000000000000
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@@ -19,27 -22,27 +22,73 @@@
  /*
   * Definitions of Primary Processor-Based VM-Execution Controls.
   */
++<<<<<<< HEAD
 +#define CPU_BASED_INTR_WINDOW_EXITING           0x00000004
 +#define CPU_BASED_USE_TSC_OFFSETTING            0x00000008
 +#define CPU_BASED_HLT_EXITING                   0x00000080
 +#define CPU_BASED_INVLPG_EXITING                0x00000200
 +#define CPU_BASED_MWAIT_EXITING                 0x00000400
 +#define CPU_BASED_RDPMC_EXITING                 0x00000800
 +#define CPU_BASED_RDTSC_EXITING                 0x00001000
 +#define CPU_BASED_CR3_LOAD_EXITING		0x00008000
 +#define CPU_BASED_CR3_STORE_EXITING		0x00010000
 +#define CPU_BASED_CR8_LOAD_EXITING              0x00080000
 +#define CPU_BASED_CR8_STORE_EXITING             0x00100000
 +#define CPU_BASED_TPR_SHADOW                    0x00200000
 +#define CPU_BASED_NMI_WINDOW_EXITING		0x00400000
 +#define CPU_BASED_MOV_DR_EXITING                0x00800000
 +#define CPU_BASED_UNCOND_IO_EXITING             0x01000000
 +#define CPU_BASED_USE_IO_BITMAPS                0x02000000
 +#define CPU_BASED_MONITOR_TRAP_FLAG             0x08000000
 +#define CPU_BASED_USE_MSR_BITMAPS               0x10000000
 +#define CPU_BASED_MONITOR_EXITING               0x20000000
 +#define CPU_BASED_PAUSE_EXITING                 0x40000000
 +#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   0x80000000
++||||||| merged common ancestors
++#define CPU_BASED_VIRTUAL_INTR_PENDING          0x00000004
++#define CPU_BASED_USE_TSC_OFFSETING             0x00000008
++#define CPU_BASED_HLT_EXITING                   0x00000080
++#define CPU_BASED_INVLPG_EXITING                0x00000200
++#define CPU_BASED_MWAIT_EXITING                 0x00000400
++#define CPU_BASED_RDPMC_EXITING                 0x00000800
++#define CPU_BASED_RDTSC_EXITING                 0x00001000
++#define CPU_BASED_CR3_LOAD_EXITING		0x00008000
++#define CPU_BASED_CR3_STORE_EXITING		0x00010000
++#define CPU_BASED_CR8_LOAD_EXITING              0x00080000
++#define CPU_BASED_CR8_STORE_EXITING             0x00100000
++#define CPU_BASED_TPR_SHADOW                    0x00200000
++#define CPU_BASED_VIRTUAL_NMI_PENDING		0x00400000
++#define CPU_BASED_MOV_DR_EXITING                0x00800000
++#define CPU_BASED_UNCOND_IO_EXITING             0x01000000
++#define CPU_BASED_USE_IO_BITMAPS                0x02000000
++#define CPU_BASED_MONITOR_TRAP_FLAG             0x08000000
++#define CPU_BASED_USE_MSR_BITMAPS               0x10000000
++#define CPU_BASED_MONITOR_EXITING               0x20000000
++#define CPU_BASED_PAUSE_EXITING                 0x40000000
++#define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   0x80000000
++=======
+ #define CPU_BASED_VIRTUAL_INTR_PENDING          VMCS_CONTROL_BIT(VIRTUAL_INTR_PENDING)
+ #define CPU_BASED_USE_TSC_OFFSETING             VMCS_CONTROL_BIT(TSC_OFFSETTING)
+ #define CPU_BASED_HLT_EXITING                   VMCS_CONTROL_BIT(HLT_EXITING)
+ #define CPU_BASED_INVLPG_EXITING                VMCS_CONTROL_BIT(INVLPG_EXITING)
+ #define CPU_BASED_MWAIT_EXITING                 VMCS_CONTROL_BIT(MWAIT_EXITING)
+ #define CPU_BASED_RDPMC_EXITING                 VMCS_CONTROL_BIT(RDPMC_EXITING)
+ #define CPU_BASED_RDTSC_EXITING                 VMCS_CONTROL_BIT(RDTSC_EXITING)
+ #define CPU_BASED_CR3_LOAD_EXITING		VMCS_CONTROL_BIT(CR3_LOAD_EXITING)
+ #define CPU_BASED_CR3_STORE_EXITING		VMCS_CONTROL_BIT(CR3_STORE_EXITING)
+ #define CPU_BASED_CR8_LOAD_EXITING              VMCS_CONTROL_BIT(CR8_LOAD_EXITING)
+ #define CPU_BASED_CR8_STORE_EXITING             VMCS_CONTROL_BIT(CR8_STORE_EXITING)
+ #define CPU_BASED_TPR_SHADOW                    VMCS_CONTROL_BIT(VIRTUAL_TPR)
+ #define CPU_BASED_VIRTUAL_NMI_PENDING		VMCS_CONTROL_BIT(VIRTUAL_NMI_PENDING)
+ #define CPU_BASED_MOV_DR_EXITING                VMCS_CONTROL_BIT(MOV_DR_EXITING)
+ #define CPU_BASED_UNCOND_IO_EXITING             VMCS_CONTROL_BIT(UNCOND_IO_EXITING)
+ #define CPU_BASED_USE_IO_BITMAPS                VMCS_CONTROL_BIT(USE_IO_BITMAPS)
+ #define CPU_BASED_MONITOR_TRAP_FLAG             VMCS_CONTROL_BIT(MONITOR_TRAP_FLAG)
+ #define CPU_BASED_USE_MSR_BITMAPS               VMCS_CONTROL_BIT(USE_MSR_BITMAPS)
+ #define CPU_BASED_MONITOR_EXITING               VMCS_CONTROL_BIT(MONITOR_EXITING)
+ #define CPU_BASED_PAUSE_EXITING                 VMCS_CONTROL_BIT(PAUSE_EXITING)
+ #define CPU_BASED_ACTIVATE_SECONDARY_CONTROLS   VMCS_CONTROL_BIT(SEC_CONTROLS)
++>>>>>>> tip-x86-cpu
  
  #define CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR	0x0401e172
  

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
