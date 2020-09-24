Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7794C4363D
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F42822208
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 21:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgIXVHQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 17:07:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:14419 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXVHP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 17:07:15 -0400
IronPort-SDR: mlEh2Im5M+qAtXzucGcnhMIUVvpxmpvdfM7aXXXmhN95gLd4hHM4hvuKCzQCVViAPcgYWEwJdJ
 OmoqBFsH+14w==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179440121"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="179440121"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:07:15 -0700
IronPort-SDR: RIaUgM3EHIJHI/0MsE4kpaigZmmc9+INXgdb1x33SaUi7GanGArNF4CMvQtVGFMQOYVIsduaJL
 K2SoJTmoXvUQ==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="487108533"
Received: from aagrawa3-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.44.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 14:07:09 -0700
Date:   Fri, 25 Sep 2020 00:07:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 18/24] x86/vdso: Add support for exception fixup in
 vDSO functions
Message-ID: <20200924210656.GF108958@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-19-jarkko.sakkinen@linux.intel.com>
 <20200923220712.GU28545@zn.tnic>
 <20200924120851.GE56811@linux.intel.com>
 <20200924160057.GK5030@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924160057.GK5030@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 06:00:57PM +0200, Borislav Petkov wrote:
> On Thu, Sep 24, 2020 at 03:09:01PM +0300, Jarkko Sakkinen wrote:
> > This is not technically SGX specific patch. Is SGX documentation the
> > correct place for this?
> 
> So what is it then? It is SGX implementation-specific. Why would you not
> put it in the documentation?!
> 
> > From checkpatch I only get:
> 
> Please concentrate and start reading more carefully:
> 
> ".git/rebase-apply/patch:122: new blank line at EOF."
> 
> Would that error come from checkpatch?

Nope. And I did fully read what you wrote. I just mentioned that more in
the tone that I should (and will) do also git am test from now on, at
least for mainline tree (when applicable) and x86 tip.

Right now the static tests that I do are checkpatch and sparse. Any
other suggestions are welcome.

I would also also coccicheck but have had some version issues with it in
Ubuntu, which I use as my host OS. Cannot recall what was the exact
issue, has been a while since I last tried it.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
