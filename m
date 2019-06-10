Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B7CC31E44
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A15720820
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 17:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387896AbfFJRg5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 13:36:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:10650 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387895AbfFJRg5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 13:36:57 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 10:36:56 -0700
X-ExtLoop1: 1
Received: from cmargarx-wtg.ger.corp.intel.com (HELO localhost) ([10.249.34.77])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jun 2019 10:36:46 -0700
Date:   Mon, 10 Jun 2019 20:36:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        luto@kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
        serge@hallyn.com, paul@paul-moore.com, eparis@parisplace.org,
        jethro@fortanix.com, dave.hansen@intel.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        nhorman@redhat.com, pmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, kai.huang@intel.com,
        rientjes@google.com, william.c.roberts@intel.com,
        philip.b.tricca@intel.com
Subject: Re: [RFC PATCH v1 0/3] security/x86/sgx: SGX specific LSM hooks
Message-ID: <20190610173645.GA13732@linux.intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <cover.1560131039.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560131039.git.cedric.xing@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 12:03:03AM -0700, Cedric Xing wrote:
> This series intends to make the new SGX subsystem and the existing LSM
> architecture work together smoothly so that, say, SGX cannot be abused to work
> around restrictions set forth by LSM. This series applies on top of Jarkko
> Sakkinen's SGX series v20 (https://lkml.org/lkml/2019/4/17/344), where abundant
> details of this SGX/LSM problem could be found.
> 
> This series is an alternative to Sean Christopherson's recent RFC series
> (https://lkml.org/lkml/2019/6/5/1070) that was trying to solve the same
> problem. The key problem is for LSM to determine the "maximal (most permissive)
> protection" allowed for individual enclave pages. Sean's approach is to take
> that from user mode code as a parameter of the EADD ioctl, validate it with LSM
> ahead of time, and then enforce it inside the SGX subsystem. The major
> disadvantage IMHO is that a priori knowledge of "maximal protection" is needed,
> but it isn't always available in certain use cases. In fact, it is an unusual
> approach to take "maximal protection" from user code, as what SELinux is doing
> today is to determine "maximal protection" of a vma using attributes associated
> with vma->vm_file instead. When it comes to enclaves, vma->vm_file always
> points /dev/sgx/enclave, so what's missing is a new way for LSM modules to
> remember origins of enclave pages so that they don't solely depend on
> vma->vm_file to determine "maximal protection".
> 
> This series takes advantage of the fact that enclave pages cannot be remapped
> (to different linear address), therefore the pair of { vma->vm_file,
> linear_address } can be used to uniquely identify an enclave page. Then by
> notifying LSM on creation of every enclave page (via a new LSM hook -
> security_enclave_load), LSM modules would be able to track origin and
> protection changes of every page, hence be able to judge correctly upon
> mmap/mprotect requests.
> 
> Cedric Xing (3):
>   LSM/x86/sgx: Add SGX specific LSM hooks
>   LSM/x86/sgx: Implement SGX specific hooks in SELinux
>   LSM/x86/sgx: Call new LSM hooks from SGX subsystem

A patch set containing direct LSM changes should consider all LSMs.
This will allow all the LSM maintainers to consider the changes. Now we
have a limited audience and we are favoring one LSM.

There is no good reason why direct LSM changes cannot be done
post-upstreaming like we do for virtualization.

Looking at Sean's patches, overally 1/5-3/5 make perfect sense.

/Jarkko
