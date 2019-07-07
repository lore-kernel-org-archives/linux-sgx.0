Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5DAC48BDB
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 18:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CDA2082F
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 18:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGGSqu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 14:46:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:11949 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfGGSqu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 14:46:50 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 11:46:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,463,1557212400"; 
   d="scan'208";a="363601580"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jul 2019 11:46:49 -0700
Date:   Sun, 7 Jul 2019 11:46:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Schaufler, Casey" <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v4 10/12] security/selinux: Add enclave_load()
 implementation
Message-ID: <20190707184648.GC19593@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-11-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551877E@ORSMSX116.amr.corp.intel.com>
 <b36d6fd0-3135-e48d-ed84-d69853bd79f1@tycho.nsa.gov>
 <CALCETrWPzSaFUWi4q4Vq_0RrtNMFZAKkwKkya=p6cfB50x2tMQ@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D558@ORSMSX116.amr.corp.intel.com>
 <CALCETrXjq9JNjXZo3Va83Ca7fiAJx7ZM9VRWYebzpyH6ug0cKg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D63B@ORSMSX116.amr.corp.intel.com>
 <CALCETrU=Btr+o9jb-zbj2kw8571WGhuhA6ZdttxQ_5_3pzZwUw@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F6551D77E@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F6551D77E@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 01, 2019 at 01:03:51PM -0700, Xing, Cedric wrote:
> > From: Andy Lutomirski [mailto:luto@kernel.org]
> > Sent: Monday, July 01, 2019 12:33 PM
> > 
> > It does make sense, but I'm not sure it's correct to assume that any LSM
> > policy will always allow execution on enclave source pages if it would
> > allow execution inside the enclave.  As an example, here is a policy
> > that seems reasonable:
> > 
> > Task A cannot execute dynamic non-enclave code (no execmod, no execmem,
> > etc -- only approved unmodified file pages can be executed).
> > But task A can execute an enclave with MRENCLAVE == such-and-such, and
> > that enclave may be loaded from regular anonymous memory -- the
> > MRENCLAVE is considered enough verification.
> 
> You are right. That's a reasonable policy. But I still can't see the need for
> SGX_EXECUNMR, as MRENCLAVE is considered enough verification.

That assumes the enclave/loader developer will never make a mistake, and
that policy owners are going to do a deep dive on the EEXTEND values for
an enclave (and will never make a mistake).

User errors aside, EXECUNMR would also be useful in conjunction with
MRSIGNER, e.g. allow all enclaves signed by X, but disallow unmeasured
code.
