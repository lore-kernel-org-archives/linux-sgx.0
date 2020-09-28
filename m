Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C56C4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 01:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D56723A34
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 01:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgI1BcS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Sep 2020 21:32:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:59193 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1BcR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 27 Sep 2020 21:32:17 -0400
IronPort-SDR: 7s1HXINaTojUkX75XwxnAVlnZc5la47pBpZZ5i38Xmi6t9h6z34qx6kdWmX5X13Q4QKwBPqO2P
 wLGAp2kmEwpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="141334704"
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="141334704"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 18:32:32 -0700
IronPort-SDR: z7ATIadBRyXkAK+MELfp+hA0tRDGW5UjM6yX9g3pnBmYt1KTv2EcbZxTphLNzveYwHeh0I2e58
 cutg2zKJUIKw==
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="488362191"
Received: from memara-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 18:32:25 -0700
Date:   Mon, 28 Sep 2020 04:32:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200928013226.GA8561@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
 <20200915110522.893152-22-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915110522.893152-22-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 15, 2020 at 02:05:19PM +0300, Jarkko Sakkinen wrote:
> +struct sgx_enclave_run {
> +	__u64 tcs;
> +	__u32 flags;
> +	__u32 exit_reason;
> +
> +	union {
> +		sgx_enclave_exit_handler_t user_handler;
> +		__u64 __user_handler;
> +	};

I will replace this with just:

	__u64 user_handler;

> +	__u64 user_data;
> +
> +	union {
> +		struct sgx_enclave_exception exception;
> +
> +		/* Pad the entire struct to 256 bytes. */
> +		__u8 pad[256 - 32];
> +	};
> +};

Resulting:


struct sgx_enclave_run {
	__u64 tcs;
	__u32 flags;
	__u32 exit_reason;
	__u64 user_handler;
	__u64 user_data;

	union {
		struct sgx_enclave_exception exception;

		/* Pad the entire struct to 256 bytes. */
		__u8 pad[256 - 32];
	};
};

BTW, why there is that padding?

/Jarkko
