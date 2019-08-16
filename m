Return-Path: <SRS0=vX2d=WM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1513C3A59C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 14:16:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F632086C
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Aug 2019 14:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfHPOQD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:16:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:1452 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbfHPOQD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Aug 2019 10:16:03 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 07:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="194999487"
Received: from ppiatekx-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.39.24])
  by fmsmga001.fm.intel.com with ESMTP; 16 Aug 2019 07:16:00 -0700
Date:   Fri, 16 Aug 2019 17:15:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 2/8] x86/sgx: Require EADD source to be page
 aligned
Message-ID: <20190816141559.3fljiersxqtguj7e@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
 <20190813011252.4121-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813011252.4121-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 12, 2019 at 06:12:46PM -0700, Sean Christopherson wrote:
> Reject the EADD ioctl() if the source address provided by userspace is
> not page aligned.  Page alignment is required by hardware, but this is
> not enforced on userspace as the kernel first copies the source page to
> an internal (page aligned) buffer.  Require the userspace address to be
> page aligned in preparation for reworking EADD to directly consume the
> userspace address.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I missed that there was this change.

For most, supporting a fast path does make sense. Removing slow path
needs to be brought up separately in the patch set review.

Even if this is still a patch set, bundling major shifts to semantics
like this is against my maintainer ethics.

I hope you get my point of view here.

/Jarkko
