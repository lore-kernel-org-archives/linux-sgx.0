Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC029C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 14:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8FBA20786
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 14:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgHRO0e (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:26:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:49348 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgHRO0d (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 10:26:33 -0400
IronPort-SDR: LOf5ZthRJlyv6JmDDA9awHUuWGHWJfUnUybI/0bw/ZiwPziWcYyPG/2eRJYGHXs+/4UF9QFIx3
 2e2AlTESHlkw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134968974"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="134968974"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 07:26:32 -0700
IronPort-SDR: 6k2SbS6PyYJK8VDtr8rqyNjsVTFPQAc2p72UKWyp5AmkJ4gsKFaDYDiptWZFwNIwDgboNTydOs
 EjFziqeP3Idg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="334385459"
Received: from ribnhajh-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.113])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Aug 2020 07:26:26 -0700
Date:   Tue, 18 Aug 2020 17:26:25 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20200818142625.GB132200@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 06, 2020 at 10:55:43AM -0400, Nathaniel McCallum wrote:
> In a past revision of this patch, I had requested a void *misc
> parameter that could be passed through vdso_sgx_enter_enclave_t into
> sgx_enclave_exit_handler_t. This request encountered some push back
> and I dropped the issue. However, I'd like to revisit it or something
> similar.
> 
> One way to create a generic interface to SGX is to pass a structure
> that captures the relevant CPU state from the handler so that it can
> be evaluated in C code before reentry. Precedent for this approach can
> be found in struct kvm_run[0]. Currently, however, there is no way to
> pass a pointer to such a structure directly into the handler.
> 
> This can be done implicitly by wrapping the struct
> sgx_enclave_exception in another structure and then using techniques
> like container_of() to find another field. However, this is made more
> difficult by the fact that the sgx_enclave_exit_handler_t is not
> really using the x86_64 sysv calling convention. Therefore, the
> sgx_enclave_exit_handler_t MUST be written in assembly. This also
> implies that we can't use techniques like container_of() and must
> calculate all the offsets manually, which is tedious, error prone and
> fragile.

If instead of having a callback, kernel would run an optional bpf
program, then a state structure could passed by the kernel to the
execution context of the bpf program.

That would also sort out difficulty of writing exit handlers.

/Jarkko
