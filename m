Return-Path: <SRS0=vy4m=YY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9834BCA9ECB
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Oct 2019 21:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6245E20862
	for <linux-sgx@archiver.kernel.org>; Thu, 31 Oct 2019 21:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfJaV37 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:29:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:22213 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbfJaV37 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 31 Oct 2019 17:29:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 14:29:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="203670345"
Received: from epobrien-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.10.103])
  by orsmga003.jf.intel.com with ESMTP; 31 Oct 2019 14:29:56 -0700
Date:   Thu, 31 Oct 2019 23:29:51 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v24] x86/sgx: Mark all regular and TCS pages as
 reclaimable
Message-ID: <20191031212928.GE10507@linux.intel.com>
References: <20191030105138.13509-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030105138.13509-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 30, 2019 at 03:51:38AM -0700, Sean Christopherson wrote:
> Mark all EADDed pages as reclaimable, not just those that are measured.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks, I merged this.

Resulted also cleaner diff between the driver and reclaimer patch:

        /*
         * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
         * can't be gracefully unwound, while failure on EADD/EXTEND is limited
@@ -374,6 +438,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
                }
        }

+       sgx_mark_page_reclaimable(encl_page->epc_page);
+
 out_unlock:
        mutex_unlock(&encl->lock);
        up_read(&current->mm->mmap_sem);

/Jarkko
