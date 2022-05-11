Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C532C433F5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 May 2022 18:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345408AbiEKSai (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 14:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245463AbiEKSai (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 14:30:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228F319CECC
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 11:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652293837; x=1683829837;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=Az2bSxbrzc2NgYjx7+VhbKN6+zRlseJy2vKB3QiHrUU=;
  b=aWB1jt5IXKYIAQJED6ovNsNiNUH4G9ih5xGyBcTNH5uFTPuKI2fJvyel
   Ogt/SYHkyL1VGrJ+vWGDW4aQU0odcGFJAcXJUr6i4zfQK+5L1/fDMKpNg
   thL/w/uhvv7eF+WaP75eyUhTp3HJKXqMe2hWehGu4+NOX03K/I4UhzODJ
   62wpbHAlsnCrgunQ8ItVwnaYA6LqC++CdkHYO2EglHoo1v9IsnqEq1TWz
   NrVzckpPWZDk4GuhP06PW8uYrTRUYJZPrFlpcJRZO2WsGxYqyaENxuiQl
   Yfr3kcVHNaRS5d3gFgS4xa6l1v7yPt19jex00H8WFmwYPHQ1VF7bycdt9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="267368490"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="267368490"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 11:30:02 -0700
X-IronPort-AV: E=Sophos;i="5.91,217,1647327600"; 
   d="scan'208";a="594264444"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.255.35.249])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 11 May 2022 11:30:00 -0700
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To:     "Kai Huang" <kai.huang@intel.com>,
        "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     "Reinette Chatre" <reinette.chatre@intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, haitao.huang@intel.com
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
References: <cover.1651171455.git.reinette.chatre@intel.com> <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com> <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com> <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com> <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com> <10a34d44-820a-ac7f-834c-65fd56513bf0@intel.com> <YnarpxzH3cEBo5pL@kernel.org> <8d44af4c-798c-4887-def6-595f18f7ac66@intel.com> <bb918c317ebb96768365b38f00239013b67ad607.camel@intel.com> <YnuPR3OW7xdEXnVF@kernel.org>
Date:   Wed, 11 May 2022 13:29:59 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: Quoted-Printable
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1l0ob9jbwjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <YnuPR3OW7xdEXnVF@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko

On Wed, 11 May 2022 05:26:15 -0500, Jarkko Sakkinen <jarkko@kernel.org> =
 =

wrote:

> On Tue, May 10, 2022 at 12:36:19PM +1200, Kai Huang wrote:
>> On Mon, 2022-05-09 at 10:17 -0700, Reinette Chatre wrote:
>> > Hi Jarkko,
>> >
>> > On 5/7/2022 10:25 AM, Jarkko Sakkinen wrote:
>> > > On Thu, Apr 28, 2022 at 04:49:00PM -0700, Reinette Chatre wrote:
>> > > > > I also looked a little deeper at this transient failure  =

>> problem.  The
>> > > > > ELDU documentation also mentions a possible error code of:
>> > > > >
>> > > > > 	SGX_EPC_PAGE_CONFLICT
>> > > > >
>> > > > > It *looks* like there can be conflicts on the SECS page as we=
ll  =

>> as the
>> > > > > EPC page being explicitly accessed.  Is that a possible probl=
em  =

>> here?
>> > > >
>> > > > I went down this path myself. SGX_EPC_PAGE_CONFLICT is an error=
  =

>> code
>> > > > supported by newer ELDUC - the ELDU used in current code would =
 =

>> indeed
>> > > > #GP in this case. The SDM text describing ELDUC as "This leaf  =

>> function
>> > > > behaves like ELDU but with improved conflict handling for  =

>> oversubscription"
>> > > > really does seem relevant to the test that triggers this issue.=

>> > > >
>> > > > I stopped pursuing this because from what I understand if
>> > > > SGX_EPC_PAGE_CONFLICT is encountered with commit 08999b2489b4  =

>> ("x86/sgx:
>> > > > Free backing memory after faulting the enclave page") then it  =

>> should
>> > > > also be encountered without it. The issue is not present with
>> > > > 08999b2489b4 ("x86/sgx: Free backing memory after faulting the
>> > > > enclave page") removed. I am thus currently investigating based=
 on
>> > > > the assumption that the #GP is encountered because of MAC
>> > > > verification problem. I may be wrong here also and need more  =

>> information
>> > > > since the SDM documents two seemingly related errors:
>> > > > #GP(0) -> If the instruction fails to verify MAC.
>> > > > SGX_MAC_COMPARE_FAIL -> If the MAC check fails.
>> > >
>> > > This part puzzles me in the pseudo-code.
>> > >
>> > > The version is read first:
>> > >
>> > > TMP_VER :=3D DS:RDX[63:0];
>> > >
>> > > Then there's MAC calculation, comparison,  and finally this check=
:
>> > >
>> > > (* Check version before committing *)
>> > > IF (DS:RDX =E2=89=A0 0)
>> > >         THEN #GP(0);
>> > > ELSE
>> > >         DS:RDX :=3D TMP_VER;
>> > > FI;
>> > >
>> > > For me it is a mystery what does zero the slot and in what condit=
ion
>> > > it would be non-zero. Perhaps the #GP refers anyway to this check=
?
>> >


We discussed this internally, and agree this part of pseudo code needs b=
e  =

corrected/clarified.

Here is what we think was going on when ELDU invoked with PCMD of all  =

zeros: ELDU would check if the PCMD.SECINFO.FLAGS.PT is 0 which indicate=
s  =

that the page being loaded is a PT_SECS, and the PAGEINFO.SECS is not  =

zero, then the instruction will #GP(0).  Thus, ELDU is behaving correctl=
y  =

=E2=80=93 it is an omission in the SDM pseudocode.

The version checking code above also need be clarified because the VA sl=
ot  =

would be cleared at this point and TMP_VER should be zero.

We will follow up with the architect once he is back from sabbatical and=
  =

make needed adjustment for SDM.

Thanks
Haitao

>> > RDX contains the VA slot information and that appears to be correct=

>> > in these scenarios. The issue is the PCMD data pointed to by the
>> > PAGEINFO.PCMD (link to PAGEINFO found in RBX) is all zeroes.
>> >
>> > There are two scenarios under which the PCMD data could be zeroes. =
 =

>> They
>> > are documented in:
>> >  =

>> https://lore.kernel.org/linux-sgx/8157fa40-8d02-8819-e1b6-fd2d8863fb5=
6@intel.com/
>> >  =

>> https://lore.kernel.org/linux-sgx/da387afc-e666-45d0-1e99-066d8c4aab0=
3@intel.com/
>> >
>> > I understand that context may be lost by pointing you to various  =

>> emails
>> > in this thread - I'll wrap up all learnings when I submit the new  =

>> version
>> > of this series today.
>> >
>>
>> Hi Reinette,
>>
>> Regardless the root cause of this problem, I agree with Jarkko above =
 =

>> pseudo-code
>> in the spec is quite confusing.  I can try to get it clarified from  =

>> Intel
>> internally if you want.
> It is :-) Yeah, it would be great if it could be made a bit more  =

> punctual!
>
> BR, Jarkko
