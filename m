Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5102C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 20:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75B720892
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 20:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="lThDeEbF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A75B720892
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbeKQHHq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 17 Nov 2018 02:07:46 -0500
Received: from mail.skyhub.de ([5.9.137.197]:57172 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbeKQHHq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 17 Nov 2018 02:07:46 -0500
X-Virus-Scanned: Nedap ESD1 at mail.skyhub.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1542401627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=DJDb5bbJBYDDRm7dybnC23DNEFcSi4NUGcifgFAm2Sw=;
        b=lThDeEbFRAkkjpcVKVQ7xBob9iBOzWijpm/B3TvAqHJyZ0YBxhC96vkvo0dCqh39hHBmGF
        HAFx0hbws0joRv1wvVUp8NQPl8PBke25G5ald9+CEhs0ks8tnTU1ao0V2t0xITNKa2scaC
        th+7fTjZxtmDasp9/1u4rf8QPryX+mE=
Received: from mail.skyhub.de ([127.0.0.1])
        by localhost (blast.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RVJ6hAojAYFT; Fri, 16 Nov 2018 21:53:47 +0100 (CET)
Received: from zn.tnic (p200300EC2BD0FE004D130AD2F34E6DE4.dip0.t-ipconnect.de [IPv6:2003:ec:2bd0:fe00:4d13:ad2:f34e:6de4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 101D31EC00E8;
        Fri, 16 Nov 2018 21:53:47 +0100 (CET)
Date:   Fri, 16 Nov 2018 21:53:34 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Kai Huang <kai.huang@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 02/23] x86/cpufeatures: Add Intel-defined SGX feature
 bit
Message-ID: <20181116205334.GO20313@zn.tnic>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-3-jarkko.sakkinen@linux.intel.com>
 <20181116142840.GI20313@zn.tnic>
 <20181116151351.GB4244@linux.intel.com>
 <20181116151845.GC4244@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181116151845.GC4244@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 05:18:45PM +0200, Jarkko Sakkinen wrote:
> I will also add Sean as co-maintainer as he has the KVM angle and is
> needed to ack patches in the future. This functionality really needs
> two eyes. Has shown to have value in many occasions.

Yap, two maintainers or a maintainer group for a bigger subsystem or
arch is always much better than a single poor dude trying to cover it
all.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
