Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B324C606C0
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04382216F4
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 14:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfGHOq3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 10:46:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:13605 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGHOq2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 10:46:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 07:46:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="340465111"
Received: from jsakkine-mobl1.tm.intel.com ([10.237.50.189])
  by orsmga005.jf.intel.com with ESMTP; 08 Jul 2019 07:46:24 -0700
Message-ID: <5af00d9857910902a99efaa9b1e590e2436c06a0.camel@linux.intel.com>
Subject: Re: [RFC PATCH v2 0/3] security/x86/sgx: SGX specific LSM hooks
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        sean.j.christopherson@intel.com
Date:   Mon, 08 Jul 2019 17:46:26 +0300
In-Reply-To: <415f8ae7-93d4-129e-4169-ffc7059398e5@intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
         <cover.1561588012.git.cedric.xing@intel.com>
         <20190703231650.bhnkn34ccrzdwwhz@linux.intel.com>
         <415f8ae7-93d4-129e-4169-ffc7059398e5@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2019-07-05 at 22:04 -0700, Xing, Cedric wrote:
> On 7/3/2019 4:16 PM, Jarkko Sakkinen wrote:
> > On Thu, Jun 27, 2019 at 11:56:18AM -0700, Cedric Xing wrote:
> > 
> > I think it is fine to have these patch sets as a discussion starters but
> > it does not make any sense to me to upstream LSM changes with the SGX
> > foundations.
> 
> Guess LSM is a gating factor, because otherwise SGX could be abused to 
> make executable EPC from pages that are otherwise not allowed to be 
> executable. Am I missing anything?

No, but what was the point? LSM is always additional gating factor.

Does not make a case for any of the proposed LSM changes.

/Jarrko

