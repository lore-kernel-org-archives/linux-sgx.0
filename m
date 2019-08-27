Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EFCC3A5A3
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57455206BF
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfH0MVa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:21:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:65088 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfH0MVa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 08:21:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 05:21:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="180210778"
Received: from jsakkine-mobl1.fi.intel.com (HELO localhost) ([10.237.66.169])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 05:21:28 -0700
Date:   Tue, 27 Aug 2019 15:21:27 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 4/4] x86/sgx: Take encl->lock inside of mm->mmap_sem for
 EADD
Message-ID: <20190827122127.h3cj7ibr2lx6zpo3@linux.intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
 <20190827001128.25066-5-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827001128.25066-5-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 05:11:28PM -0700, Sean Christopherson wrote:
> Reverse the order in which encl->lock and mm->mmap_sem are taken during
> ENCLAVE_ADD_PAGE so as to adhere to SGX's lock ordering requirements.
> Attempting to acquire mm->mmap_sem while holding encl->lock can result
> in deadlock.
> 
> Refactor EEXTEND and the final bookkeeping out of __sgx_encl_add_page()
> so that mm->mmap_sem can be dropped after EADD without spreading the
> lock/unlock across multiple functions.
> 
> Reported-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks, looks good.

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
