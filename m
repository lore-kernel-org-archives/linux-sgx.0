Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA53CC3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 855FF233FE
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbfHVQbm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:31:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:8135 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbfHVQbm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:31:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="196283605"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by fmsmga001.fm.intel.com with ESMTP; 22 Aug 2019 09:31:40 -0700
Message-ID: <d0e8313b7817a43151b11602ad55b1136f614850.camel@linux.intel.com>
Subject: Re: [PATCH 4/5] x86/sgx: Validate TCS permssions in
 sgx_validate_secinfo()
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Date:   Thu, 22 Aug 2019 19:31:39 +0300
In-Reply-To: <20190822035510.GV29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-5-jarkko.sakkinen@linux.intel.com>
         <20190822035510.GV29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 20:55 -0700, Sean Christopherson wrote:
> Why are we validating the TCS protection bits?  Hardware ignores them, so
> why do we care?  sgx_ioc_enclave_add_page() sets the internal protection
> bits so there's no danger of putting the wrong thing in the page tables.

I think that in this commit I got it wrong but I think this is awkward:

	/*
	 * TCS pages must always RW set for CPU access while the SECINFO
	 * permissions are *always* zero - the CPU ignores the user provided
	 * values and silently overwrites with zero permissions.
	 */
	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
		prot |= PROT_READ | PROT_WRITE;

In my opinion the right thing to do would be check that SECINFO has *at
minimum* RW and return -EINVAL if not.

I don't like the SGX silently adjusting permissions like this.

/Jarkko

