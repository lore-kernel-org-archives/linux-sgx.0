Return-Path: <SRS0=KcaY=XU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE846C432C2
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 19:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9872F21D79
	for <linux-sgx@archiver.kernel.org>; Wed, 25 Sep 2019 19:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfIYTI1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Sep 2019 15:08:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:42952 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfIYTI1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Sep 2019 15:08:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 12:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,549,1559545200"; 
   d="scan'208";a="364420786"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 25 Sep 2019 12:08:26 -0700
Date:   Wed, 25 Sep 2019 12:08:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190925190825.GK31852@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190924202210.GC16218@linux.intel.com>
 <20190925085156.GA3891@zn.tnic>
 <20190925171824.GF31852@linux.intel.com>
 <20190925183136.GH3891@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925183136.GH3891@zn.tnic>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 08:31:36PM +0200, Borislav Petkov wrote:
> On Wed, Sep 25, 2019 at 10:18:24AM -0700, Sean Christopherson wrote:
> > Realistically, there will likely be a non-trivial number of systems with
> > SGX_LE_WR=0 but SGX enabled.
> 
> Well no. We won't support those. I remember very vividly at Tech Days a
> couple of years ago where we said we won't support locked down systems.

Yep, that's our intent as well.

> > It's inevitable that some systems will lock down the LE hash MSRs, either
> > intentionally or due to lack of support for SGX_LE_WR.  The latter is
> > probably going to be more common than OEMs intentionally locking the MSRs,
> > because some Intel reference BIOSes simply don't support SGX_LE_WR, e.g. I
> > have a Coffee Lake SDP that has hardware support for SGX_LC, but the BIOS
> > doesn't provide any way to set SGX_LE_WR or leave FEATURE_CONTROL unlocked.
> 
> We won't support those too. Nothing changes since a couple of years ago.
> We won't support locked down systems and unfinished BIOS systems.

Yep.

> ... reading your other mail about KVM...
> 
> I guess KVM could be an exception here if people wanna run different
> OSes in the guest. IMHO.
>
> For that, though, we should still clear all SGX feature bits in the
> host, I'd say, and let the kvm module rediscover everything itself
> through CPUID directly and not using *cpu_has*
> 
> Why, you ask? Because otherwise users will start asking why do they have
> "sgx" in /proc/cpuinfo but they can't run their own enclaves.

That makes sense.  I was thinking it'd be helpful to leave the bits set,
e.g. for users to differentiate between "I don't have SGX" and "I can't
use SGX because SGX_LC is disabled".  But I'm probably being slightly
optomistic...

> But maybe someone has a better idea.
> 
> In any case, I think it would be bad idea to show only a subset of
> features in /proc/cpuinfo of a locked-down system and have to explain it
> to users why they can't do own enclaves.
> 
> But again, someone might have a better idea.

I'm 99% certain this won't even require a change to the proposed KVM
patches, as KVM mostly pulls SGX support directly from CPUID.  The only
thing it checks via cpu_has() is SGX_LC to query whether or not the MSRs
are fully writable.

Keeping the SGX feature bits set was more about reflecting hardware
capabilities than it was a functional requirement.
