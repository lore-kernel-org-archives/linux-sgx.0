Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEA3C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA272173E
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733143AbfHHPo3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:44:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:54608 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732845AbfHHPo2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:44:28 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="193179606"
Received: from sandersb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.239])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2019 08:44:26 -0700
Date:   Thu, 8 Aug 2019 18:44:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 05/11] x86/sgx: Require EADD source to be page
 aligned
Message-ID: <20190808154351.3jsh75ryezomussw@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808001254.11926-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:48PM -0700, Sean Christopherson wrote:
> Reject the EADD ioctl() if the source address provided by userspace is
> not page aligned.  Page alignment is required by hardware, but this is
> not enforced on userspace as the kernel first copies the source page to
> an internal (page aligned) buffer.  Require the userspace address to be
> page aligned so that the driver can, in the future, directly consume the
> userspace address via EADD without breaking backwards compatibility,
> e.g. to avoid the overhead of alloc+memcpy.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Not sure about this. Why not just implement a fast path when the address is
aligned (in future)?

/Jarkko
