Return-Path: <SRS0=JJHd=2X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF87C2D0DC
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 17:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ACFB20866
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 17:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgABRMt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jan 2020 12:12:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:41651 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgABRMt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jan 2020 12:12:49 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 09:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="221419739"
Received: from krominsx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.21.64])
  by orsmga006.jf.intel.com with ESMTP; 02 Jan 2020 09:12:47 -0800
Date:   Thu, 2 Jan 2020 19:12:47 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25] x86/sgx: Move the intermediate EINIT helper into
 the driver
Message-ID: <20200102171226.GC17637@linux.intel.com>
References: <20191221005053.27620-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191221005053.27620-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 20, 2019 at 04:50:53PM -0800, Sean Christopherson wrote:
> Move sgx_einit() into the driver code, along with the LE hash MSR
> management.  Providing sgx_einit() in the common SGX code was a bit
> premature.  The thought was that the native SGX driver and KVM would
> be able to use a common EINIT helper, but that may or may not hold
> true depending on how KVM's implementation shakes out.  For example,
> KVM may want to pass user pointers directly to EINIT in order to
> avoid copying large amounts of data to in-kernel temp structures.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thank you. I merged this patch and also added a changelog entry about
merging driver and EINIT patch.

/Jarkko
