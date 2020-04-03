Return-Path: <SRS0=nYZY=5T=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E96C43331
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 22:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4631F2078C
	for <linux-sgx@archiver.kernel.org>; Fri,  3 Apr 2020 22:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgDCWIy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:08:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:11040 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCWIx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Apr 2020 18:08:53 -0400
IronPort-SDR: vtG20doi7qRCsA0hYwEGsqKRMhutBwREEDEdTWZIJLq4dHJXm2SCsIWoiI5mWgJx5ts9JKmEJ4
 kfBFLubpjHNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 15:08:53 -0700
IronPort-SDR: 7fRg9IO7Q74c8BCYkpg3Imfiye64s7Sys/R0IL5wNLrXYySBALVHX8IyGcedQi6zNFFTl56hEM
 6L4BnTRdeo4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,341,1580803200"; 
   d="scan'208";a="450168742"
Received: from jmarndt-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.39.65])
  by fmsmga005.fm.intel.com with ESMTP; 03 Apr 2020 15:08:49 -0700
Date:   Sat, 4 Apr 2020 01:08:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200403220848.GA7588@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
 <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
 <CALCETrXz4YK9ubCAyBLm4BjqYEK-wt1491QPLDyumJe9t0LJ2A@mail.gmail.com>
 <20200401002443.GE4847@linux.intel.com>
 <CALCETrW8pLFRAnQdpxuBG-CDuUN5B8T-FqN5TvAVD--ZR=78-Q@mail.gmail.com>
 <20200403065621.GB25305@linux.intel.com>
 <f8698536-074e-6562-05df-26145a4c43b9@schaufler-ca.com>
 <20200403153041.GA2787@linux.intel.com>
 <105cf6a1-cd6a-016a-3557-dda0e5c7d9b5@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105cf6a1-cd6a-016a-3557-dda0e5c7d9b5@schaufler-ca.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 03, 2020 at 08:50:08AM -0700, Casey Schaufler wrote:
> > How does smackfs interact with namespaces?
> 
> Smack attributes are global. Aside from privilege issues, namespaces
> ignore and are ignored by Smack.

Okay.

For SGX, I foresee things as:

1. Existing files are global.
2. If a policy of any kind is ever added it needs to be *per container*.
   I'm not sure whether PID or user namespace is the right choice here,
   but does not matter right now as the feature is not in the queue.

To summarize:

1. We have a heterogeneous set of files (i.e. 'enclave' and 'provision'
   are not "different sames").
2. The files probably will have heterogeneous visibility requirements.

I think based on these premises own file system would be a more decent
choice than populating /dev. Beside, SGX hasn't been a driver for a
while.

Andy, what do you think of this?

/Jarkko
