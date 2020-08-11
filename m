Return-Path: <SRS0=Le6A=BV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD6FC433E0
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 14:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 063052083B
	for <linux-sgx@archiver.kernel.org>; Tue, 11 Aug 2020 14:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgHKOyW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:54:22 -0400
Received: from mga07.intel.com ([134.134.136.100]:2519 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728782AbgHKOyW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Aug 2020 10:54:22 -0400
IronPort-SDR: XTGlnp38V0h8qVuF+6ImYXoIDCKWjkOU7llLohBjwjLeKnFt0+mhg3AWiVHwDdDchSU3HvFHWJ
 F3Q1zYNCLZOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="218086088"
X-IronPort-AV: E=Sophos;i="5.76,300,1592895600"; 
   d="scan'208";a="218086088"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 07:54:21 -0700
IronPort-SDR: 1cnu5xRtZE2IK/CTJ8kWdwVLTqJVQGNU5sRO3yamEKzU/MEHgviA18IszQ45Qs4M/AASVC7nAk
 j9+Ju6sBtC5Q==
X-IronPort-AV: E=Sophos;i="5.76,300,1592895600"; 
   d="scan'208";a="326871090"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2020 07:54:20 -0700
Date:   Tue, 11 Aug 2020 07:54:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>, kai.huang@intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, kmoy@google.com,
        ludloff@google.com, luto@kernel.org,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200811145419.GC20623@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com>
 <78ba0baf-8ffa-7221-4ac1-007dd9e7eb20@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78ba0baf-8ffa-7221-4ac1-007dd9e7eb20@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 11, 2020 at 09:16:28AM +0200, Jethro Beekman wrote:
> On 2020-08-11 00:23, Sean Christopherson wrote:
> > Another thought would be to wrap sgx_enclave_exception in a struct to give
> > room for supporting additional exit information (if such a thing ever pops
> > up) and to allow the caller to opt in to select behavior, e.g. Jethro's
> > request to invoke the exit handler on IRQ exits.  This is basically the
> > equivalent of "struct kvm_run", minus the vCPU/enclave state.
> 
> Actually, the flag I need is “return from the vdso on IRQ exits” (See Andy's
> email about preferring returns over callbacks). But maybe the flag should be
> “interpret IRQ exit as a normal exit” and let it be handled the same as any
> other exit based on whether an exit handler fnptr was passed or not.

Ya, slip of the tongue, the behavior would apply to both paths.
