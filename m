Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B729DC77B73
	for <linux-sgx@archiver.kernel.org>; Sat, 27 May 2023 00:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjE0AdA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 26 May 2023 20:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjE0Ac7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 26 May 2023 20:32:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC0125
        for <linux-sgx@vger.kernel.org>; Fri, 26 May 2023 17:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685147578; x=1716683578;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=juDtNkeCJZeG8AIH6MZL5FpFpAG7SFA7oG61JF8B23A=;
  b=bkohi9WSQcmVZJkJ0ALI3Cv5aBMTexQDG5piGPxnl+xHfx1eoS4d9bw7
   oGymZqtL7ncJn31DdQrDJK3zpGJ9ONjZQ2uOXPP/EQ3dfc3r1t3IQcmA0
   NbtAx9uOFPdwgXewEjFCYbtt8/IjJw3mz9Pjugw0GE41Zmb4L6zFUsrD/
   SFsoMlHEKT+g0eAH0vPVOMzo2Kub9mjeCnBUx6EaNvPusqltB2n9HlgvW
   FUjbX9GcSThw7Vu7Cx9LGVNnNppj9Nkr8uoPRMtzkVFRBhDVg0kDV21VC
   Au8QtbY/Sw3i5QAkuD+a4ee8j2Z5HFzHOiQwkofdowcoE5JNfSZ49Ee+Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="417820090"
X-IronPort-AV: E=Sophos;i="6.00,195,1681196400"; 
   d="scan'208";a="417820090"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 17:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="705386470"
X-IronPort-AV: E=Sophos;i="6.00,195,1681196400"; 
   d="scan'208";a="705386470"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.48.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 26 May 2023 17:32:57 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v4 2/4] x86/sgx: Implement support for MADV_WILLNEED
References: <3c7b4f7bf3e7c2a213662b1c9fdaa979050a9327.camel@intel.com>
 <op.10dekzjhwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <39903b057751d963e4e9b2a8cd5271fe3c102509.camel@intel.com>
 <op.10dk8lsjwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <c37bb20995f234aa724724a06c96c76f18252e66.camel@intel.com>
 <op.10d2otjlwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ef4087489625b0f8403c38e61348010dba62f623.camel@intel.com>
 <op.10ey84qywjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/AAbC/j04aUkd8R@kernel.org>
 <op.10i8zfw3wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <Y/VBOkmi7VbVuzAh@kernel.org>
 <op.10qusgctwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <5de607230294552829b075846a66688f65f3f74e.camel@intel.com>
 <op.11iklswmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
Date:   Fri, 26 May 2023 19:32:56 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.15kug6t9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <e65d5e589e404f37b3f9ea15a2fd8e132d9040a1.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Kai, Jarkko and Dave

On Thu, 09 Mar 2023 05:31:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:
>
> So I am still a little bit confused about where does "SGX driver uses
> MAP_ANONYMOUS semantics for fd-based mmap()" come from.
>
> Anyway, we certainly don't want to break userspace.  However, IIUC, even  
> from
> now on we change the driver to depend on userspace to pass the correct  
> pgoff in
> mmap(), this won't break userspace, because old userspace which doesn't  
> use
> fadvice() and pgoff actually doesn't matter.  For new userspace which  
> uses
> fadvice(), it needs to pass the correct pgoff.
>
> I am not saying we should do this, but it doesn't seem we can break  
> userspace?
>

Sorry for delayed update but I thought about this more and likely to  
propose a new EAUG ioctl for this and for enabling SGX-CET shadow stack  
pages. But regardless, I'd like to wrap up this discussion to just clarify  
this anonymous semantics design in documentation so people won't get  
confused in future.

I think we all agree to keep this semantics so no user space would need  
specify 'offset' for mmap with enclave fd. And here is my proposed  
documentation changes.

--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -100,6 +100,23 @@ pages and establish enclave page permissions.
                 sgx_ioc_enclave_init
                 sgx_ioc_enclave_provision

+Enclave memory mapping
+----------------------
+
+A file descriptor created from opening **/dev/sgx_enclave** represents an
+enclave object. The mmap() syscall with enclave file descriptors does not
+support non-zero value for the 'offset' parameter.
+
+Rational:
+
+Enclave mapping is very similar to anonymous mapping in that it maps  
physical
+EPC pages to virtual addresses and the physical pages need not be  
contiguous. And
+the content of each enclave page must be loaded at an expected offset  
relative
+to SECS.BASEADDR as is reflected in measurements in its SIGSTRUCT.  
Otherwise
+EINIT would fail to verify the measurements and initialize the enclave.  
This is
+unlike regular file mapping in that no content offset can be defined that  
is
+independent from the virtual address it is loaded to.
+
  Enclave runtime management
  --------------------------

Let me know your thoughts and I can submit the patch if you think this is  
the direction to go.

Thanks
Haitao
