Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83404C3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 08:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61521206BA
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 08:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfHZIUi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 04:20:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:14136 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfHZIUi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 04:20:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 01:20:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="184885418"
Received: from dcondura-mobl.ger.corp.intel.com (HELO localhost) ([10.249.37.53])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2019 01:20:34 -0700
Date:   Mon, 26 Aug 2019 11:20:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Serge Ayoun <serge.ayoun@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sean Christoherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix sgx_ioc_enclave_add_page() documentation
Message-ID: <20190826082033.3m75n7ukcc4i6umr@linux.intel.com>
References: <20190826053248.4403-1-jarkko.sakkinen@linux.intel.com>
 <20190826055934.cb6gsvueoe4jife3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826055934.cb6gsvueoe4jife3@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 08:59:34AM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 26, 2019 at 08:32:48AM +0300, Jarkko Sakkinen wrote:
> > Refine the kdoc of sgx_ioc_enclave_add_page() with a proper description
> > about the interaction with mmap(). Without documentation, it is
> > impossible to review the code change.
> > 
> > Cc: Serge Ayoun <serge.ayoun@intel.com>
> > Cc: Casey Schaufler <casey@schaufler-ca.com>
> > Cc: Sean Christoherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> I squashed this.

Further defined the documentation to also address TCS:

/**
 * sgx_ioc_enclave_add_page() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGE
 * @filep:	open file to /dev/sgx
 * @arg:	a user pointer to a struct sgx_enclave_add_page instance
 *
 * Add (EADD) a page to an uninitialized enclave, and optionally extend
 * (EEXTEND) the measurement with the contents of the page. A SECINFO for a TCS
 * is required to always contain zero permissions because CPU silently zeros
 * them. Allowing anything else would cause a mismatch in the measurement.
 *
 * mmap()'s protection bits are capped by the page permissions. For each page
 * address, the maximum protection bits are computed with the following
 * heuristics:
 *
 * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
 * 2. A TCS page: PROT_R | PROT_W.
 * 3. No page: PROT_NONE.
 *
 * mmap() is not allowed to surpass the minimum of the maximum protection bits
 * within the given address range.
 *
 * As stated above, a non-existent page is interpreted as a page with no
 * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
 * an address range for the enclave that can be then populated into SECS.
 *
 * Return:
 *   0 on success,
 *   -EINVAL if the SECINFO contains invalid data,
 *   -EACCES if the source page is located in a noexec partition,
 *   -ENOMEM if any memory allocation, including EPC, fails,
 *   -errno otherwise
 */

Saw no point to cycle this here other than mention about the change. I'd
say now it starts to be throughout enough.

/Jarkko
