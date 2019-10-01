Return-Path: <SRS0=+C2n=X2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9189BC352AA
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 19:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CEC21783
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 19:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfJATel (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Oct 2019 15:34:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:31492 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbfJATel (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Oct 2019 15:34:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 12:34:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="205134393"
Received: from yexing-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by fmsmga001.fm.intel.com with ESMTP; 01 Oct 2019 12:34:34 -0700
Date:   Tue, 1 Oct 2019 22:34:26 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com
Subject: Re: [PATCH v22 24/24] docs: x86/sgx: Document kernel internals
Message-ID: <20191001193307.GB12699@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-25-jarkko.sakkinen@linux.intel.com>
 <97dbd2a8-f1e5-a3f9-dac7-f1f4d6b6cd4c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97dbd2a8-f1e5-a3f9-dac7-f1f4d6b6cd4c@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 27, 2019 at 10:07:10AM -0700, Randy Dunlap wrote:
> On 9/3/19 7:26 AM, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Document some of the more tricky parts of the kernel implementation
> > internals.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Hi,
> Some edits for you to consider.

Thank you, great comments!

> > +ultimately all the launch decisions token are not needed for anything.  We
> 
>    ultimately makes all the launch decisions, tokens are not

Here I rephrased the whole sentence as tokens are only single purpose.
The current form implies as if they were multipurpose. Also the last
sentence was just the first sentence rephrased differently.

I also more information about the launch and I ended up with this:

"The current kernel implementation supports only writable MSRs. The launch is
performed by setting the MSRs to the hash of the public key modulus of the
enclave signer and a token with the valid bit set to zero.

If the MSRs were read-only, the platform would need to provide a launch enclave
(LE), which would be signed with the key matching the MSRs. The LE creates
cryptographic tokens for other enclaves that they can pass together with their
signature to the ENCLS(EINIT) opcode, which is used to initialize enclaves."

/Jarkko
