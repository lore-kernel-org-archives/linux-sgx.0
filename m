Return-Path: <SRS0=rVAO=42=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641C3C10F25
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Mar 2020 21:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D2F62146E
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Mar 2020 21:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCIVO2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Mar 2020 17:14:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:57456 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgCIVO1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Mar 2020 17:14:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 14:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,534,1574150400"; 
   d="scan'208";a="388696169"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 09 Mar 2020 14:14:27 -0700
Date:   Mon, 9 Mar 2020 14:14:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v28 06/22] x86/sgx: Add wrappers for ENCLS leaf functions
Message-ID: <20200309211425.GA19235@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-7-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303233609.713348-7-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 04, 2020 at 01:35:53AM +0200, Jarkko Sakkinen wrote:
> +/* Issue a WARN() about an ENCLS leaf. */
> +#define ENCLS_WARN(r, name) {						  \
> +	do {								  \
> +		int _r = (r);						  \
> +		WARN(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \

This should be a WARN_ONCE(), otherwise we'll spam the log if something
goes awry, e.g. if there's a correctable #MC or a rogue write to a MCi_CTL
MSR, either of which will "soft" disable SGX (CPUID 0x7 still reports
SGX/SGXLC support, but all CPUID 0x12 sub-leafs return zeros).

> +	} while (0);							  \
> +}
