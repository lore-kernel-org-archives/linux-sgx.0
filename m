Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A4EC31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34CCA214AF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 14:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfFSOqt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:46:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:27060 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfFSOqs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 10:46:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 07:46:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="335210932"
Received: from stephanf-mobl2.ger.corp.intel.com ([10.252.34.117])
  by orsmga005.jf.intel.com with ESMTP; 19 Jun 2019 07:46:44 -0700
Message-ID: <0db45877621c83000165ca3a5e2590bbeb05b276.camel@linux.intel.com>
Subject: Re: [RFC PATCH v3 05/12] x86/sgx: Enforce noexec filesystem
 restriction for enclaves
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     luto@kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <20190617222438.2080-6-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
         <20190617222438.2080-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Wed, 19 Jun 2019 17:46:32 +0300
User-Agent: Evolution 3.32.1-2 
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> Do not allow an enclave page to be mapped with PROT_EXEC if the source
> vma does not have VM_MAYEXEC.  This effectively enforces noexec as
> do_mmap() clears VM_MAYEXEC if the vma is being loaded from a noexec
> path, i.e. prevents executing a file by loading it into an enclave.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Andy, I recall you questioning this earlier. What was your argument
and what are your thoughts ATM?

/Jarkko

