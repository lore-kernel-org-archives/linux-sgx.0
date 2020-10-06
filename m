Return-Path: <SRS0=YsX3=DN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EE8C41604
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 08:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF602078E
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Oct 2020 08:30:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="aN6EFJyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFIac (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Oct 2020 04:30:32 -0400
Received: from mail-eopbgr690125.outbound.protection.outlook.com ([40.107.69.125]:32847
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725891AbgJFIac (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Oct 2020 04:30:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AY77kUj+8fTxrHdEG6JCuwsgBqgXVxXn0cGT9vsY0/LFRe4kyBsiMSQ3VAQzD8mC82re8GRaC/MXg+Am4Kzpaku3VaLV5AUpn/qUZrgkbxx44YWVkh6jbh+pV1BogyxbXZKx6oNq3SiowzJCdxkQ3DGDacvEppRvu3ZmoG4uQ8l5gTQ+Jno7pG9FGcfaQHth+RNvrSDJwtvhbgdKdiQgyCxXKSjhKSKLNAWVN2YKe5FTEzUDjMWCd24WF7SbsQMXGObRYnrmY/PeR9t5G05AHVspEfQ26EgfVgG0ryh2OpHJYrw93waqQn81VWrYm3NPr8dT1e1Ppc+zxw64pROk4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP6ebqBnd7YH+X7/wl4WnEe/bElRek3t+6hx3NlhXE4=;
 b=oTytmOZwn72+1DnCVxO79DJmk4cksfZ30XbdNQ2bz7mHwiJfz3uKaL6XHpyvgozvUrlytFsxkhCYIeuuLFViJLhUelybxrFJZ6bHqh6bVphNThYpnZyut9fdz/jMe404XhvNUn3ACTtWWjckjYc1XyAyk8RDRkX0W2NtkPOnFxal3Yacbx5ll5aEUSQ8B4z6aamE0D4FnmF9i26YhlC4ZfIq4KbM3txL1AW1VWyiDm6LvzHGPCcePqUfKCbolapPYE97rdwXXQeDGCzg6waKbGmuaUzhzciP8GTZWb5oD4I+i+CXDIUxbnHPInMHpx2t6ZNwaEqAbD+Gq1mnVHTQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VP6ebqBnd7YH+X7/wl4WnEe/bElRek3t+6hx3NlhXE4=;
 b=aN6EFJyj0QdaWhqtKf4o+GgVMjEFNfjzK6fDjMi0uy13ecLBxJxfJSox0PKF+fiKHRnfBZecqIfuaGZtrHEQNlZRH/dSCi1bIrFUAY/YFNG8cfXHt1hjn2iM4FP1CsaShTewafOmD7/iRN40lLWCB484eoiJvo487bjZhhbM148=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB2677.namprd11.prod.outlook.com (2603:10b6:a02:cd::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.38; Tue, 6 Oct
 2020 08:30:27 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 08:30:27 +0000
Subject: Re: [PATCH v39 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-22-jarkko.sakkinen@linux.intel.com>
 <20201006025703.GG15803@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <453c2d9b-0fd0-0d63-2bb9-096f255a6ff4@fortanix.com>
Date:   Tue, 6 Oct 2020 10:30:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201006025703.GG15803@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070309000707020104000907"
X-Originating-IP: [213.127.14.5]
X-ClientProxiedBy: AM4PR07CA0009.eurprd07.prod.outlook.com
 (2603:10a6:205:1::22) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.14.5) by AM4PR07CA0009.eurprd07.prod.outlook.com (2603:10a6:205:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.16 via Frontend Transport; Tue, 6 Oct 2020 08:30:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a739a96-5d7b-442e-ed31-08d869d213be
X-MS-TrafficTypeDiagnostic: BYAPR11MB2677:
X-Microsoft-Antispam-PRVS: <BYAPR11MB2677F43D65AD41371A5CC8DAAA0D0@BYAPR11MB2677.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcQqr4Vd7V4C03nUeZqFChmVB2TCRLlTLcMdLDAX6+A/F/cThpW6FpfGgJGJRT9DE379c1NRfIDFnpROcMRicjhEoCPD6UP22ffwY5Yg+o+LyL/ENS32/+YBlRKuJxAmL2lJB0crgH0yOF8dUsz6dVEhbpm7exxgzeDKqFLTLz8HxxJ8j2AbKtUPigq61JQqToreuYMSWZvVu73JeC+SX6AOMjHWvVAnCBGe4qh8/OQY12Ucm+bgrh9AEopGmZpvM/5GVo+QcRBDkbDZgrnNV/+z9h1r8mt/kyilNGzdq1CrJ8ijRPFEOfeJtoX5smslKjPj9uDTyUGDf8wXJuiSrB3zSfy9n0ljU8JiLm9LyNIxivnu0uRljpcPe6zl2zmK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39840400004)(396003)(136003)(346002)(8676002)(4326008)(2906002)(316002)(36756003)(16576012)(5660300002)(235185007)(8936002)(86362001)(2616005)(6486002)(53546011)(66946007)(6666004)(66556008)(956004)(7416002)(186003)(31696002)(26005)(54906003)(66476007)(31686004)(83380400001)(16526019)(52116002)(33964004)(110136005)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4PfrY1xIlW70hlcn1VdnEbYiDni2Cme/XCvtw1ksGHiyBsplhfLcmK1a3jMPcWstjqPU20dXkG5mjvLhojmN22uEIh0Od1iv4ZySKbm9XnBdJLCVYGAy/eTz9Dd9sjxiWJiDc74Uy+GRO+eG95XbzcqOC4dCn2K72TWeCGW77Oog8xPD6hs/lQMcO9cgIreuf/vVH0kqjocNtcgDBi4gyhgcQ4N3Ei5ITDuOnGRhe/q2bBk9UUpsqqHuefSx8Sg+rn5R0DnajG0IPTewJqNQZ0Sa9hv3hPfke4LspXYUwxYbj1eURsrveFLKBazlxpx0EJfxeORUESow7Tbh9utMgb3TOHX7CRmNprv7rLp8maj5raHq2KrZ4qQtwn2MbELgUGTwfiMbQX7I33BIsuE6llG4dnLCH9ndJJDfhy6wN7uWIltJfublo9wXkptmUJK0qdF6H9lffGVhQYXjGjfqSjE6tuqEBT1KY2zyM2JLyFcwnuFYa4PvgZBhxXVMH5okTKbtmPy7ojPWTcdNQoB3QagpM05wwYEht+71WzZxkBjINTcP/T1tIe6cfhEg0+sBb2uqBEr/ia8GhulLCiPdQOdG6N1nlS29eJ3OguxFqQ7QYdrD0uN1tn7B6rSIM1rgpLcwrusN8aSRcMT7vMdBjg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a739a96-5d7b-442e-ed31-08d869d213be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2020 08:30:27.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uA2oW+6cqUnfU74UkhEEr2OlIZSlKoY1nii9Y+QIKvXO1KZleA94g/2F8hNxxk8MSbAOEc23VCUlSUsS4CVWoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2677
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070309000707020104000907
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-10-06 04:57, Sean Christopherson wrote:
> On Sat, Oct 03, 2020 at 07:50:56AM +0300, Jarkko Sakkinen wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>> +	/* Validate that the reserved area contains only zeros. */
>> +	push	%rax
>> +	push	%rbx
>> +	mov	$SGX_ENCLAVE_RUN_RESERVED_START, %rbx
>> +1:
>> +	mov	(%rcx, %rbx), %rax
>> +	cmpq	$0, %rax
>> +	jne	.Linvalid_input
>> +
>> +	add	$8, %rbx
>> +	cmpq	$SGX_ENCLAVE_RUN_RESERVED_END, %rbx
>> +	jne	1b
>> +	pop	%rbx
>> +	pop	%rax
>=20
> This can more succinctly be (untested):
>=20
> 	movq	SGX_ENCLAVE_RUN_RESERVED_1(%rbp), %rbx=09
> 	orq	SGX_ENCLAVE_RUN_RESERVED_2(%rbp), %rbx=09
> 	orq	SGX_ENCLAVE_RUN_RESERVED_3(%rbp), %rbx=09
> 	jnz	.Linvalid_input
>=20
> Note, %rbx is getting clobbered anyways, no need to save/restore it.
>=20
>> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/a=
sm/sgx.h
>> index b6ba036a9b82..3dd2df44d569 100644
>> --- a/arch/x86/include/uapi/asm/sgx.h
>> +++ b/arch/x86/include/uapi/asm/sgx.h
>> @@ -74,4 +74,102 @@ struct sgx_enclave_provision {
>>  	__u64 attribute_fd;
>>  };
>> =20
>> +struct sgx_enclave_run;
>> +
>> +/**
>> + * typedef sgx_enclave_user_handler_t - Exit handler function accepte=
d by
>> + *					__vdso_sgx_enter_enclave()
>> + * @run:	Pointer to the caller provided struct sgx_enclave_run
>> + *
>> + * The register parameters contain the snapshot of their values at en=
clave
>> + * exit
>> + *
>> + * Return:
>> + *  0 or negative to exit vDSO
>> + *  positive to re-enter enclave (must be EENTER or ERESUME leaf)
>> + */
>> +typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rd=
x,
>> +					  long rsp, long r8, long r9,
>> +					  struct sgx_enclave_run *run);
>> +
>> +/**
>> + * struct sgx_enclave_run - the execution context of __vdso_sgx_enter=
_enclave()
>> + * @tcs:			TCS used to enter the enclave
>> + * @user_handler:		User provided callback run on exception
>> + * @user_data:			Data passed to the user handler
>> + * @leaf:			The ENCLU leaf we were at (EENTER/ERESUME/EEXIT)
>> + * @exception_vector:		The interrupt vector of the exception
>> + * @exception_error_code:	The exception error code pulled out of the =
stack
>> + * @exception_addr:		The address that triggered the exception
>> + * @reserved			Reserved for possible future use
>> + */
>> +struct sgx_enclave_run {
>> +	__u64 tcs;
>> +	__u64 user_handler;
>> +	__u64 user_data;
>> +	__u32 leaf;
>=20
> I am still very strongly opposed to omitting exit_reason.  It is not at=
 all
> difficult to imagine scenarios where 'leaf' alone is insufficient for t=
he
> caller or its handler to deduce why the CPU exited the enclave.  E.g. s=
ee
> Jethro's request for intercepting interrupts.

Not entirely sure what this has to do with my request, I just expect to s=
ee leaf=3DERESUME in this case, I think? E.g. as you would see in EAX whe=
n calling ENCLU.

--
Jethro Beekman | Fortanix



--------------ms070309000707020104000907
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBu
kmvE8GLB9+EYd88699DiMA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDEwMDYwODMwMTZaMC8GCSqGSIb3DQEJBDEiBCDz
pRsuk5Ro44mOhwDbPwzab+j6FLhcYp1iYQj1BRnc+zBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCEG6Sa8TwYsH34Rh3zzr30OIwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhBukmvE8GLB9+EYd88699DiMA0G
CSqGSIb3DQEBAQUABIIBABASzjoqcL5oBUjPXM5wEbPiQAk9U/FSY0yoQzvZU2B6Ji8VaGhI
0HvLNXSPc+VFzjM3gSKbehiqC4DTc+tKvKV2yt+2mknkfWuLJiWCaBjISMPV+25jJMSRa3DD
uXwt7w2sWE1GS+ywbfp16LHqnlfEQPzoH7oNR/My3qAGxflOipNceBv3aBWaRbsQumGjx2E+
IE3WhgnWwwDJhlrUlT6FERuqoCzZIzmigQkCCNjhFIiI/0eCj0MiCTWcpO5S+hPDzYmZJE+G
wYmpByJV3dQL6Gwa+KdCmqL2YUAU3FkyGmk1vATh6qXFVy8NN2eRpGKv6//l9JQRed7jmMko
uqMAAAAAAAA=

--------------ms070309000707020104000907--
