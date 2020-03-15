Return-Path: <SRS0=qxyk=5A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA682C0044D
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 01:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CB5920771
	for <linux-sgx@archiver.kernel.org>; Sun, 15 Mar 2020 01:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCOB2k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Mar 2020 21:28:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:28478 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgCOB2k (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 14 Mar 2020 21:28:40 -0400
IronPort-SDR: OSHhI0BtLsbUJhS4gyun97prmK0J/hx0AYK7hvzgnl4XNfQdfVmrPx/wT7RiuxBcVBeuw2ygkA
 6hnZsgkxaBjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 18:25:35 -0700
IronPort-SDR: 7dXMEkMlPBhCsDZMMGbFY2QSBSl03GSPFEkuh4wHq6I0PEu1I9WX6dq7pEhJpxQ+ewL9QtLlQ4
 EAHtV3T75Gow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,554,1574150400"; 
   d="scan'208";a="278653419"
Received: from mbenhamu-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.177.145])
  by fmsmga002.fm.intel.com with ESMTP; 14 Mar 2020 18:25:25 -0700
Date:   Sun, 15 Mar 2020 03:25:23 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200315012523.GC208715@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 11, 2020 at 01:30:07PM -0400, Nathaniel McCallum wrote:
> Currently, the selftest has a wrapper around
> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> registers (CSRs), though it uses none of them. Then it calls this
> function which uses %rbx but preserves none of the CSRs. Then it jumps
> into an enclave which zeroes all these registers before returning.
> Thus:
> 
>   1. wrapper saves all CSRs
>   2. wrapper repositions stack arguments
>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
>   4. selftest zeros all CSRs
>   5. wrapper loads all CSRs
> 
> I'd like to propose instead that the enclave be responsible for saving
> and restoring CSRs. So instead of the above we have:
>   1. __vdso_sgx_enter_enclave() saves %rbx
>   2. enclave saves CSRs
>   3. enclave loads CSRs
>   4. __vdso_sgx_enter_enclave() loads %rbx
> 
> I know that lots of other stuff happens during enclave transitions,
> but at the very least we could reduce the number of instructions
> through this critical path.

What Jethro said and also that it is a good general principle to cut
down the semantics of any vdso as minimal as possible.

I.e. even if saving RBX would make somehow sense it *can* be left
out without loss in terms of what can be done with the vDSO.

/Jarkko
