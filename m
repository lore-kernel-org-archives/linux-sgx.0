Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82ACC742A1
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 00:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADA52084B
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 00:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfGLAId (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 20:08:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:55804 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728635AbfGLAId (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 20:08:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 17:08:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="168785441"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2019 17:08:32 -0700
Subject: Re: [RFC PATCH v4 00/12] security: x86/sgx: SGX vs. LSM
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190705160549.tzsck5ho5kvtdhit@linux.intel.com>
 <20190708172930.GA20791@linux.intel.com>
 <20190709162203.gzyvulah5u7eksip@linux.intel.com>
 <20190709170917.GD25369@linux.intel.com>
 <20190710221638.bwnwtcozpv44ojdg@linux.intel.com>
 <38d3b0ee-be9c-cb1a-785a-325a3ade003b@intel.com>
 <20190711092609.jxe4uubwg5qbwfju@linux.intel.com>
 <ef0c9052-d22e-aaa6-4915-b1823abea64c@tycho.nsa.gov>
 <20190711175151.xwxdfbvxbm6esymk@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <00bdd94d-308a-47fc-00d4-a0f93e171b6a@intel.com>
Date:   Thu, 11 Jul 2019 17:08:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711175151.xwxdfbvxbm6esymk@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/2019 10:51 AM, Jarkko Sakkinen wrote:
> On Thu, Jul 11, 2019 at 10:32:41AM -0400, Stephen Smalley wrote:
>> The existing permissions don't map cleanly to SGX but I think Sean and
>> Cedric were trying to make a best-effort approximation to the underlying
>> concepts in a manner that permits control over the introduction of
>> executable content.
>>
>> Sure, the existing EXECMOD check is only applied today when there is an
>> attempt to make executable a previously modified (detected based on COW
>> having occurred) private file mapping.  But the general notion of
>> controlling the ability to execute modified content is still meaningful.
> 
> OK to summarize EXECMOD does not connect with SGX in any possible way
> but SGX needs something that mimics EXECMOD behaviour?

Stephen may correct me if I'm wrong. EXECMOD is granted to files, to 
indicate the bearer contains self-modifying code (or text relocation). 
So if it applies the enclaves, there are two aspects of it:

(1) An enclave may be loaded from multiple image files, among which some 
may contain self-modifying code and hence would require EXECMOD on each 
of them. At runtime, W->X will be allowed/denied for pages loaded from 
image files having/not having EXECMOD.

(2) But there are pages not loaded from any files - e.g. pages EAUG'ed 
at runtime. We are trying to use the file containing SIGSTRUCT as the 
"proxy file" - i.e. EXECMOD on the proxy file indicates the enclave may 
load code into EAUG'ed pages at runtime.

(3) Well, this is not an aspect of EXECMOD. Yet there's another category 
of pages - pages EADD'ed from anonymous memory. They are different than 
EAUG'ed pages in that their contents are supplied by untrusted code. How 
to control their accesses is still being debated. My argument was that 
the source pages must be executable before they could be loaded 
executable in EPC. Andy argued that SIGSTRUCT alone could be considered 
sufficient validation on the contents in certain usages, so both Sean 
and I had proposed PROCESS2__ENCLAVE_EXECANON as a new permission. But 
for the 1st upstream I think we all agree to do just the minimum until 
real requirements come up. After all, adding is generally easier than 
taking away existing things.
