Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929E5C606C7
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 18:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7426B216FD
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 18:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfGHSt5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 14:49:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:3728 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfGHSt5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 14:49:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 11:49:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="192409163"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jul 2019 11:49:55 -0700
Date:   Mon, 8 Jul 2019 11:49:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com
Subject: Re: [RFC PATCH v3 0/4] security/x86/sgx: SGX specific LSM hooks
Message-ID: <20190708184955.GC20791@linux.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <20190708155524.GD20433@linux.intel.com>
 <8ba6c32d-cedc-53fd-9e86-f78be0067ac3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ba6c32d-cedc-53fd-9e86-f78be0067ac3@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jul 08, 2019 at 10:49:59AM -0700, Xing, Cedric wrote:
> On 7/8/2019 8:55 AM, Sean Christopherson wrote:
> >On Sun, Jul 07, 2019 at 04:41:30PM -0700, Cedric Xing wrote:
> True only for SGX1.
> >>     “maximal protection” at page load time, but such information is NOT always
> >>     available. For example, Graphene containers may run different applications
> >>     comprised of different set of executables and/or shared objects. Some of
> >>     them may contain self-modifying code (or text relocation) while others
> >>     don’t. The generic enclave loader usually doesn’t have such information so
> >>     wouldn’t be able to provide it ahead of time.
> >
> >I'm unconvinced that it would be remotely difficult to teach an enclave
> >loader that an enclave or hosted application employs SMC, relocation or
> >any other behavior that would require declaring RWX on all pages.
> 
> You've been talking as if "enclave loader" is tailored to the enclave it is
> loading. But in reality "enclave loader" is usually a library knowing
> usually nothing about the enclave. How could it know if an enclave contains
> self-modifying code?

Given the rarity of SMC, require enclaves to declare "I do SMC"...  The
Intel SDK already requires the enclave developer to declare heap size,
stack size, thread affinity, etc...  I have a very hard time believing
that it can't support SMC and relocation flags.
 
> >>   · Inefficient Auditing – Audit logs are supposed to help system
> >>     administrators to determine the set of minimally needed permissions and to
> >>     detect abnormal behaviors. But consider the “maximal protection” model, if
> >>     “maximal protection” is set to be too permissive, then audit log wouldn’t
> >>     be able to detect anomalies;
> >
> >Huh?  Declaring overly permissive protections is only problematic if an
> >LSM denies the permission, in which case it will generate an accurate
> >audit log.
> >
> >If the enclave/loader "requires" a permission it doesn't actually need,
> >e.g. EXECDIRTY, then it's a software bug that should be fixed.  I don't
> >see how this scenario is any different than an application that uses
> >assembly code without 'noexecstack' and inadvertantly "requires"
> >EXECSTACK due to triggering "read implies exec".  In both cases the
> >denied permission is unnecessary due to a userspace application bug.
> 
> You see, you've been assuming "enclave loader" knows everything and tailored
> to what it loads in a particular application. But the reality is the loader
> is generic and probably shared by multiple applications. 

No, I'm assuming that an enclave can communicate its basic needs without
undue pain.

> It needs some generic way to figure out the "maximal protection". An
> implementation could use information embedded in the enclave file, or could
> just be "configurable". In the former case, you put extra burdens on the build
> tools, while in the latter case, your audit logs cannot help generating an
> appropriate configuration.

I'm contending the "extra burdens" is minimal.

  if (do_smc || do_relocation)
          max_prot = RWX;
  else
          max_prot = SECINFO.FLAGS;

> >>     or if “maximal protection” is too restrictive,
> >>     then audit log cannot identify the file violating the policy.
> >
> >Maximal protections that are too restrictive are completely orthogonal to
> >LSMs as the enclave would fail to run irrespective of LSMs.  This is no
> >different than specifying the wrong RWX flags in SECINFO, or opening a
> >file as RO instead of RW.
> 
> Say loader is configurable. By looking at the log, can an administrator tell
> which file has too restrictive "maximal protection"?

Again, this fails irrespective of LSMs.  So the answer is "no", because
there is no log.  But the admin will never have to deal with this issue
because the enclave will *never* run, i.e. would unconditionally fail to
run during initial development.  And the developer has bigger problems if
they can't debug their own code.

> >>In either case the audit log cannot fulfill its purposes.
