Return-Path: <SRS0=xaf1=3C=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB477C33CAD
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 14:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B31E42073D
	for <linux-sgx@archiver.kernel.org>; Mon, 13 Jan 2020 14:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="QKsILdYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgAMOEQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Jan 2020 09:04:16 -0500
Received: from mail.skyhub.de ([5.9.137.197]:43064 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgAMOEQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 13 Jan 2020 09:04:16 -0500
Received: from zn.tnic (p200300EC2F05D3007144E525CFA9AFEA.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:d300:7144:e525:cfa9:afea])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1B6AB1EC0CBF;
        Mon, 13 Jan 2020 15:04:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1578924255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=UQY15Z2WD87EH/GvLiVF7DoOpjCBedypQJNX6g6F96c=;
        b=QKsILdYKSTAtFEzj5tXc/VvWusZhNPH6jCrHeaF1APAZ3aY9/3B3aGEs/qPw5sFY3r0Ulu
        GKjO3lHzd204tAz7FpbAEUUasFWDooBg5pq2NuxtCA5PELJ7UtZywc7lNsEKzcqMzOTwhc
        aj06aj/nulwTZT4inVHZ+c5i4mdJzmQ=
Date:   Mon, 13 Jan 2020 15:04:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: v25-rc1
Message-ID: <20200113140407.GI13310@zn.tnic>
References: <20200113035918.GA32455@linux.intel.com>
 <20200113084810.GB13310@zn.tnic>
 <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <95fc04cb-c305-2ef1-2449-ecb37796c661@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jan 13, 2020 at 03:00:49PM +0100, Paolo Bonzini wrote:
> Sorry I missed that.  What about sending me a topic branch, that will be
> merged into both tip and kvm-next?

... and I'll put all patches in it except the KVM ones:

  KVM: VMX: Drop initialization of IA32_FEAT_CTL MSR
  KVM: VMX: Use VMX feature flag to query BIOS enabling
  KVM: VMX: Check for full VMX support when verifying CPU compatibility
  KVM: VMX: Use VMX_FEATURE_* flags to define VMCS control bits
  KVM: VMX: Allow KVM_INTEL when building for Centaur and/or Zhaoxin CPUs

which you can then take?

Makes sense to me...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
