Return-Path: <SRS0=jAuJ=V5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785C6C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Aug 2019 16:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C482087E
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Aug 2019 16:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfHAQir (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Aug 2019 12:38:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:15207 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731966AbfHAQiq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Aug 2019 12:38:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 09:38:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="177880414"
Received: from muelc-mobl.ger.corp.intel.com (HELO localhost) ([10.252.51.57])
  by orsmga006.jf.intel.com with ESMTP; 01 Aug 2019 09:38:40 -0700
Date:   Thu, 1 Aug 2019 19:38:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190801163839.wvcnq57hity4wwrk@linux.intel.com>
References: <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com>
 <20190620221702.GE20474@linux.intel.com>
 <20190707190809.GE19593@linux.intel.com>
 <1b7369a08e98dd08a4f8bb19b16479f12bee130f.camel@linux.intel.com>
 <20190708161932.GE20433@linux.intel.com>
 <20190709160634.3yupyabf5svnj4ds@linux.intel.com>
 <20190710172553.GE4348@linux.intel.com>
 <CALCETrXMAwHod_KZYPGWjTjg-fxOb1=02=Qj2g1o624wOPfPZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXMAwHod_KZYPGWjTjg-fxOb1=02=Qj2g1o624wOPfPZQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 15, 2019 at 03:29:23PM -0700, Andy Lutomirski wrote:
> I would say it differently: regardless of exactly how /dev/sgx/enclave
> is wired up under the hood, we want a way that a process can be
> granted permission to usefully run enclaves without being granted
> permission to execute whatever bytes of code it wants.  Preferably
> without requiring LSMs to maintain some form of enclave signature
> whitelist.

Would it be better to have a signer whitelist instead or some
combination? E.g. you could whiteliste either by signer or
enclave signature.

/Jarkko
