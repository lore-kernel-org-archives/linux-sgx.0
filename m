Return-Path: <SRS0=SeXc=WG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CF2C32751
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F7972166E
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfHJLXv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 10 Aug 2019 07:23:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:20378 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfHJLXv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 10 Aug 2019 07:23:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Aug 2019 04:23:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,369,1559545200"; 
   d="scan'208";a="259289271"
Received: from agudipat-mobl.ger.corp.intel.com (HELO localhost) ([10.249.36.164])
  by orsmga001.jf.intel.com with ESMTP; 10 Aug 2019 04:23:48 -0700
Date:   Sat, 10 Aug 2019 14:23:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is
 naturally aligned
Message-ID: <20190810112347.kzg3jcmh6z2euiv5@linux.intel.com>
References: <20190810003051.15712-1-sean.j.christopherson@intel.com>
 <d38b3d14-a30d-88b0-ac60-a71d4577ca16@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38b3d14-a30d-88b0-ac60-a71d4577ca16@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Aug 10, 2019 at 12:39:54AM +0000, Jethro Beekman wrote:
> On 2019-08-09 17:30, Sean Christopherson wrote:
> > Manually align ELRANGE now that the kernel doesn't automatically do so
> > for SGX mappings.
> 
> What was the rationale for moving this out of the kernel? Now every user of
> this API needs to implement it manually.

VMAs are viewports to the enclave, not the enclave. You can even fully
create and initialize an enclave without creating VMAs. Thus, binding
must be a loose one.

/Jarkko
