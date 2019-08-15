Return-Path: <SRS0=qhvV=WL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BBEC3A589
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 22:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0912083B
	for <linux-sgx@archiver.kernel.org>; Thu, 15 Aug 2019 22:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731813AbfHOWAO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 15 Aug 2019 18:00:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:12166 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731709AbfHOWAO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 15 Aug 2019 18:00:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 15:00:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="171235117"
Received: from schuberw-mobl.ger.corp.intel.com (HELO localhost) ([10.252.38.145])
  by orsmga008.jf.intel.com with ESMTP; 15 Aug 2019 15:00:11 -0700
Date:   Fri, 16 Aug 2019 01:00:09 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH for_v22 v2 0/8] x86/sgx: Remove EADD worker and page copy
Message-ID: <20190815220009.lnjtydyi3rqhkaiu@linux.intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813011252.4121-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 12, 2019 at 06:12:44PM -0700, Sean Christopherson wrote:
> As suggested by Andy, remove the work queue in favor of handling the
> entire EADD flow in the context of the ioctl().  After the worker is
> gone, pass the source page/address directly to EADD instead of first
> copying the data into kernel memory.
> 
> v2:
>   - Rebase to master, commit 36e0186296a7.
>   - Incorporate patch to require EADD be aligned, and add a selftest
>     update to obey the new alignment requirement.

Looks great!

I'll squash these and some selftest changes and send the next version
of the patch set. Thank you.

/Jarkko
