Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B32CC74A35
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 17:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13C3A214AF
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 17:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfGJRZz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 13:25:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:26994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfGJRZz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 13:25:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 10:25:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="173918101"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2019 10:25:54 -0700
Date:   Wed, 10 Jul 2019 10:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190710172553.GE4348@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com>
 <20190620221702.GE20474@linux.intel.com>
 <20190707190809.GE19593@linux.intel.com>
 <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
 <20190708161932.GE20433@linux.intel.com>
 <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 09, 2019 at 07:06:34PM +0300, Jarkko Sakkinen wrote:
> On Mon, Jul 08, 2019 at 09:19:32AM -0700, Sean Christopherson wrote:
> > > 2. Probably some "user story" type of examples would help with the
> > > discussion overall [1] i.e. how one would use this for
> > > her own good.
> > 
> > The compelling story is Andy's original concern that userspace could
> > circumvent existing security policies by running code in an enclave.
> > 
> > AIUI, closing the LSM loophole is the minimal requirement to get SGX
> > upstreamed.  The extensive discussion has largely been focused on
> > ensuring that whatever mechanism is used to close the loophole will
> > play nice with future SGX functionality and/or LSM security policies.
> 
> OK, might be getting here where I fall out of the wagon so:
> 
> Doesn't Andy's example anyway require a process that has privileges to
> make pages executable i.e. it could run arbitrary code even without an
> enclave?

Ah, no.  He did raise that concern, but it'd only be an issue if the
enclave fd were backed by an anon inode, in which case all enclaves would
need EXECMEM in order to gain PROT_EXEC on EPC.  Because the fd is backed
/dev/sgx/enclave, userspace just needs FILE__EXECUTE on /dev/sgx/enclave.
