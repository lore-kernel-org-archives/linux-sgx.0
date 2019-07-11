Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBE9C74A5C
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD992084B
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 16:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="hjgKo1bE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfGKQLN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 12:11:13 -0400
Received: from uhil19pa10.eemsg.mail.mil ([214.24.21.83]:61395 "EHLO
        uhil19pa10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbfGKQLM (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 11 Jul 2019 12:11:12 -0400
X-EEMSG-check-017: 427553950|UHIL19PA10_EEMSG_MP8.csd.disa.mil
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by uhil19pa10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 11 Jul 2019 16:11:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1562861469; x=1594397469;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ImN0EkNwA0U9cgVGBL9lp9v2mtWYc6o++hHqdQ7IFhg=;
  b=hjgKo1bEzYazb/OnGCQqSqdAbtQxMwYJtCYN1siju57WInlevLCMshi8
   CYSnDEca7ATCzEYTrPjZknReA1hIBG+SI49O1DfwQiedzEQjZuovOVbcK
   zVweVyibC3U4T2AsOnGn/md0uYhE/0qXHbHyr0MRTYlBsteFZcYa//HfV
   eVm1o8Qr8eDuQJ/BVPvS3T93aPCudqmn8o9EstGl5+UN2d3xXb70XHlR2
   68HNSNkK/21nlX4MBjSIBck8JEI0N25pj37I6ossVLDH657zUwEliUvhj
   cYCgTpLGPcC39gvhTMIs+LRFQjbyp/wyPspE30P8qWcstjmFD5cOEze+7
   w==;
X-IronPort-AV: E=Sophos;i="5.63,479,1557187200"; 
   d="scan'208";a="25611627"
IronPort-PHdr: =?us-ascii?q?9a23=3AKSJvIhLeTaDDaG7NRdmcpTZWNBhigK39O0sv0r?=
 =?us-ascii?q?FitYgXKPvyrarrMEGX3/hxlliBBdydt6sezbaG+PGxEUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCejbb9oIxi7rgrdu80SjIB/Nqs/1x?=
 =?us-ascii?q?zFr2dSde9L321oP1WTnxj95se04pFu9jlbtuwi+cBdT6j0Zrw0QrNEAjsoNW?=
 =?us-ascii?q?A1/9DrugLYTQST/HscU34ZnQRODgPY8Rz1RJbxsi/9tupgxCmXOND9QL4oVT?=
 =?us-ascii?q?i+6apgVQTlgzkbOTEn7G7Xi9RwjKNFrxKnuxx/2JPfbIWMOPZjYq/RYdYWSG?=
 =?us-ascii?q?xPUcZLUyxKH52yYY0BAeEcOepUtonwql8LoRa4GAKiBv7gyiVQi3Hrw6M63e?=
 =?us-ascii?q?QvHwLI0gMuEN0BsmjbotruOacOU+241rXEwSnNYv5U3zr29YjGcgomofGJRb?=
 =?us-ascii?q?9+bNbRxlc3FwPFkFqQr5HuMS6Q1usXt2ib6/RvVOKygGMgsAF+vyOvy9wwio?=
 =?us-ascii?q?jJmo0VylfE+T9/wIYuP9K0UkF7Ydm6EJZJsSyRKoh4Qts6Tm11tys3xacKtJ?=
 =?us-ascii?q?6mcCQQ1pgqyADTZ+aaf4WO/xntTvyeIS1ii3JgYL+/ghGy/lW+xeDkTcm01U?=
 =?us-ascii?q?pKrjJCktnRqnABzxzT5daDSvt65kqhxSyA1xrS6uFZOkA4j7bbKp49zb4wkZ?=
 =?us-ascii?q?ofq0LDETPtmErqlqOWc0Qk+uyw5+TmZLXpuIOcOpdphgzxPakigMyyDfkiPg?=
 =?us-ascii?q?QQUGWX5/6w2KD78U38WrpKj/k2kqfDsJDdIMQWvrW5DBJO0os49xa+Dyup0N?=
 =?us-ascii?q?QfnXUdKlJFYwiIg5LmO1HJPvD0Fe2/jEi0kDd32/DGOaXsAo7TIXfZlrftZ7?=
 =?us-ascii?q?R951RAxwoz19Bf5olUCq0GIPLrWk/+qsbYDgQ+Mwyy2OvnCdN91p8AVmKLGK?=
 =?us-ascii?q?OWLKTSsVqQ7OI1P+aMfJMVuCr6K/U9+/Hhk2I2mUUcfaa1x5cWZ3G4HvJpI0?=
 =?us-ascii?q?iCYHrshMsBHnkOvgYkUOPqj1iCWyZJZ3muR6I8+i07CIW+AIjfXI+tm6KO3S?=
 =?us-ascii?q?egE51Nem9GCkqDEWrmd4WARfgMcjueLdN7nTAeSbehTIoh3wm0tADm07pnMv?=
 =?us-ascii?q?bU+ioAuJLn1dh14fDTlB4r+TxvAMSc3HqAT397nmwWXT86xqN/rlJnyleFz6?=
 =?us-ascii?q?d4h+ZUFdtJ5/NGSg06L4LTz/RmC9DuXQLMZtOJSFegQtW7DjA9V8kxzMESbE?=
 =?us-ascii?q?ZgAdWijwzD3iqzD78QkLyEGYE08qbC0HXqOcZ9xGjJ1LM7g1klXMRPL2umib?=
 =?us-ascii?q?B79wTJAI7JiUqZnb6wdasAxC7N6HuDzW2WsUFDTgFwVaTFXXYCZkrZttn5+E?=
 =?us-ascii?q?zCQKG0Cbg9MQtO19SCKq1UZd3tl1lGQ+3jONvGaWKrh2iwHQqIxq+LbIfyeW?=
 =?us-ascii?q?Ud2SLdCFIekwAS5naLLg4+CT2ko23ADTxiD1XvY1nj8eNmsnO0Ulc0zx2Wb0?=
 =?us-ascii?q?1mz7e14gQaheGYS/4IxrILojohqzFtEFa42NLWDMCAqBR7cKpAZtM95QQP6W?=
 =?us-ascii?q?WMjAF0ONSLL7pjnUIZawR6pVjp0V0jEYhJl44o6ngq1gtpNaWA0F5bbDSe9Z?=
 =?us-ascii?q?H2JrDTbGL1+Ub8RbTR3wTlzNuO+qoJoM89olHnsRDhQlEu6F17wtJV1D2a/Z?=
 =?us-ascii?q?yMAw0MB8GiGn0r/gR38umJKhI24JnZgDg1bPi5?=
X-IPAS-Result: =?us-ascii?q?A2BPAAAUXydd/wHyM5BlGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?4FtKmpSMiiEHJJeUwaBCS2JXo8ugWcJAQEBAQEBAQEBIxEBAgEBhEACglMjO?=
 =?us-ascii?q?BMBAwEBAQQBAQEBBAEBbIU8DII6KQGCZwEFIxVBEAsYAgImAgJXBg0IAQESg?=
 =?us-ascii?q?k0/AYF2FKxGgTKFR4MtgUeBDCiLXxd4gQeBOII2By4+hBEBEgGDKYJYBJRsl?=
 =?us-ascii?q?QJtCYIbgh+EOY0qBhuCLG2Uao5kmCghZ3ErCAIYCCEPgycJhimKbyMDMIEGA?=
 =?us-ascii?q?QGMTIJDAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 11 Jul 2019 16:11:08 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x6BGB6t6019502;
        Thu, 11 Jul 2019 12:11:06 -0400
Subject: Re: [RFC PATCH v3 3/4] X86/sgx: Introduce EMA as a new LSM module
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>
References: <cover.1562542383.git.cedric.xing@intel.com>
 <41e1a1a2f66226d88d45675434eb34dde5d0f50d.1562542383.git.cedric.xing@intel.com>
 <fb4352a4-7ef4-6824-a2ab-21e5fcb208ae@schaufler-ca.com>
 <ce4dcce2-88fb-ccec-f173-fc567d9ca006@intel.com>
 <decc7ae6-a89f-1ae5-6289-f3dcaa6390b0@schaufler-ca.com>
 <1f5b5fc1-9a95-9748-f9dc-0486c6ae30d8@intel.com>
 <34552999-160e-4f60-8d7e-37f51c895ef4@schaufler-ca.com>
 <e2a0d952-b4d4-f8f3-ee58-eba63f30dc66@intel.com>
 <4c3e21dd-8890-e3cb-0db7-c154ac7201e1@tycho.nsa.gov>
 <20190711151245.GD7645@linux.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <27e55a96-d5c4-69ed-a88d-7a3c26fb7f75@tycho.nsa.gov>
Date:   Thu, 11 Jul 2019 12:11:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190711151245.GD7645@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/11/19 11:12 AM, Sean Christopherson wrote:
> On Thu, Jul 11, 2019 at 09:51:19AM -0400, Stephen Smalley wrote:
>> I'd also feel better if there was clear consensus among all of the
>> @intel.com participants that this is the right approach. To date that has
>> seemed elusive.
> 
> That's a very kind way to phrase things :-)
> 
> For initial upstreaming, we've agreed that there is no need to extend the
> uapi, i.e. we can punt on deciding between on-the-fly tracking and having
> userspace specify maximal permissions until we add SGX2 support.
> 
> The last open (knock on wood) for initial upstreaming is whether SELinux
> would prefer to have new enclave specific permissions or reuse the
> existing PROCESS__EXECMEM, FILE__EXECUTE and FILE__EXECMOD permissions.
> My understanding is that enclave specific permissions are preferred.

I was left unclear on this topic after the email exchanges with Cedric.
There are at least three options:

1) Reuse the existing EXECMEM, EXECUTE, and EXECMOD permissions.  Pros: 
Existing distro policies will be applied in the expected manner with 
respect to the introduction of executable code into the system, 
consistent control will be provided over the enclave and the host 
process, no change for users/documentation wrt policy.  Cons: Existing 
permissions don't map exactly to SGX semantics, no ability to 
distinguish executable content within the enclave versus the host 
process at the LSM level (argued earlier by Cedric to be unnecessary and 
perhaps meaningless), need to allow FILE__EXECUTE or other checks on 
sigstruct files that may not actually contain code.

2) Define new permissions within existing security classes (e.g. 
process2, file). Pros: Can tailor permission names and definitions to 
SGX semantics, ability to distinguish enclave versus host process 
execute access, no need to grant FILE__EXECUTE to sigstruct files, class 
matches the target object, permissions computed and cached upon existing 
checks (i.e. when a process accesses a file, all of the permissions to 
that file are computed and then cached at once, including the 
enclave-related ones).  Cons: Typical distro policies (unlike Android) 
allow unknown permissions by default for forward kernel compatibility 
reasons, so existing policies will permit these new permissions by 
default and enforcement will only truly take effect once policies are 
updated, adding new permissions to existing classes requires an update 
to the base policy (so they can't be shipped as a third party policy 
module alongside the SGX driver or installed as a local module by an 
admin, for example), documentation/user education required for new 
permissions.

3) Define new permissions in new security classes (e.g. enclave). Pros 
relative to #2: New classes and permissions can be defined and installed 
in third party or local policy module without requiring a change to the 
base policy.  Cons relative to #2: Class won't correspond to the target 
object, permissions won't be computed and cached upon existing checks 
(only when performing the checks against the new classes).

Combinations are also possible, of course.
