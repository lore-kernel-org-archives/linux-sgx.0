Return-Path: <SRS0=rFfE=UN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C157FC31E45
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97F6120850
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Jun 2019 00:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfFNAiA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 20:38:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:13724 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfFNAiA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 20:38:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 17:37:59 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 13 Jun 2019 17:37:59 -0700
Date:   Thu, 13 Jun 2019 17:37:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
Message-ID: <20190614003759.GE18385@linux.intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F65502A85@ORSMSX116.amr.corp.intel.com>
 <b7f3decf-b1d2-01b1-6294-ccf9ba2d5df4@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f3decf-b1d2-01b1-6294-ccf9ba2d5df4@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 02:00:29PM -0400, Stephen Smalley wrote:
> On 6/11/19 6:55 PM, Xing, Cedric wrote:
> >*_noaudit() is exactly what I wanted. But I couldn't find
> >selinux_file_mprotect_noaudit()/file_has_perm_noaudit(), and I'm reluctant
> >to duplicate code. Any suggestions?
> 
> I would have no objection to adding _noaudit() variants of these, either
> duplicating code (if sufficiently small/simple) or creating a common helper
> with a bool audit flag that gets used for both. But the larger issue would
> be to resolve how to ultimately ensure that a denial is audited later if the
> denied permission is actually requested and blocked via sgxsec_mprotect().

I too would like to see a solution to the auditing issue.  I wrongly
assumed Cedric's approach (option #3) didn't suffer the same auditing
problem as Andy's dynamic tracking proposal (option #2).  After reading
through the code more carefully (trying to steal ideas to finish off an
implementation of #2), I've come to realize options #2 (Andy) and #3
(Cedric) are basically identical concepts, the only difference being who
tracks state.

We can use the f_security blob sizes to identify which LSM denied
something, but I haven't the faintest idea how to track the auditing
information in a sane fashion.  We'd basically have to do a deep copy on
struct common_audit_data, or pre-generate and store the audit message.
For SELinux, a deep copy is somewhat feasible because selinux_audit_data
distills everything down to basic types.  AppArmor on the other hand has
'struct aa_label *label', which at a glance all but requires pre-generating
the audit message, and since AppArmor logs denials from every profile, it's 
possible the "sgx audit blob" will consume a non-trivial amount of data.

Even if we figure out a way to store the audit messages without exploding
memory consumption or making things horrendously complex, we still have a
problem of reporting state info.  Any number of things could be removed or
modified by the time the audit is actually triggered, e.g. files removed,
AppArmor profiles modified, etc...  Any such change means we're logging
garbage.
